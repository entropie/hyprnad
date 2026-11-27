#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"

module DeviceBattery
  class Error < StandardError; end

  Reading = Struct.new(:level, :charging, keyword_init: true) do
    def initialize(level: nil, charging: false)
      valid_level = level.is_a?(Numeric) && level.between?(0, 100)
      super(level: valid_level ? level : nil, charging: charging)
    end

    def available?
      !level.nil? || charging
    end

    def text
      [level && "#{level.round}%", charging && "⚡"].select(&:itself).join(" ")
    end
  end

  class Command
    def initialize(timeout: 10)
      @timeout = timeout
    end

    def call(*args)
      stdout, stderr, status = Open3.capture3(
        { "LC_ALL" => "C" },
        "timeout", "#{@timeout}s", *args
      )

      unless status.success?
        detail = status.exitstatus == 124 ? "timed out" : stderr.strip
        raise Error, "#{args.first}: #{detail} (exit #{status.exitstatus})"
      end

      stdout
    end
  end

  class Device
    attr_reader :name

    def initialize(name:, command: Command.new)
      @name = name
      @command = command
    end

    # Return a Reading, or nil when the device is unavailable.
    def read
      raise NotImplementedError, "#{self.class} must implement #read"
    end

    private

    attr_reader :command
  end

  # Reusable for any battery device reported by UPower.
  class UPowerDevice < Device
    def initialize(serial:, **options)
      super(**options)
      @serial = serial
    end

    def read
      fields = devices.find { |device| device["serial"] == @serial }
      return unless fields && fields["present"] == "yes"

      percentage = fields["percentage"]

      Reading.new(
        level: percentage && Float(percentage.delete_suffix("%")),
        charging: fields["state"] == "charging"
      )
    end

    private

    def devices
      command.call("upower", "-d").split("Device:").map do |block|
        block.lines.filter_map do |line|
          key, separator, value = line.strip.partition(":")
          [key, value.strip] unless separator.empty?
        end.to_h
      end
    end
  end

  # Reusable for headsets supported by HeadsetControl.
  class HeadsetControlDevice < Device
    AVAILABLE_STATES = %w[
      BATTERY_AVAILABLE
      BATTERY_CHARGING
    ].freeze

    def initialize(vendor_id:, product_id:, **options)
      super(**options)
      @vendor_id = vendor_id
      @product_id = product_id
    end

    def read
      data = JSON.parse(command.call("headsetcontrol", "-b", "-o", "json"))

      device = data.fetch("devices", []).find do |entry|
        entry["id_vendor"] == @vendor_id &&
          entry["id_product"] == @product_id
      end

      battery = device&.fetch("battery", nil)
      return unless battery
      return unless AVAILABLE_STATES.include?(battery["status"])

      Reading.new(
        level: battery["level"],
        charging: battery["status"] == "BATTERY_CHARGING"
      )
    end
  end

  class Waybar
    def initialize(warning: 30, critical: 15)
      @warning = warning
      @critical = critical
    end

    def render(device, reading)
      return { text: "" } unless reading&.available?

      {
        text: reading.text,
        tooltip: "#{device.name}: #{reading.text}",
        class: css_class(reading)
      }
    end

    private

    def css_class(reading)
      return "charging" if reading.charging
      return "critical" if reading.level <= @critical
      return "warning" if reading.level <= @warning

      "normal"
    end
  end

  class CLI
    def initialize(devices:, formatter: Waybar.new)
      @devices = devices
      @formatter = formatter
    end

    def run(args)
      unless args.length == 1 && @devices.key?(args.first)
        warn "Usage: #{$PROGRAM_NAME} #{@devices.keys.join('|')}"
        puts JSON.generate(text: "")
        return 1
      end

      device = @devices.fetch(args.first)
      puts JSON.generate(@formatter.render(device, device.read))
      0
    rescue StandardError => error
      warn "#{args.first}: #{error.message}"
      puts JSON.generate(text: "")
      1
    end
  end
end

if $PROGRAM_NAME == __FILE__
  devices = {
    "mouse" => DeviceBattery::UPowerDevice.new(
      name: "Logitech G Pro",
      serial: "7f-05-04-f6"
    ),
    "headset" => DeviceBattery::HeadsetControlDevice.new(
      name: "Logitech PRO X Wireless",
      vendor_id: "0x046d",
      product_id: "0x0aba"
    )
  }

  exit DeviceBattery::CLI.new(devices: devices).run(ARGV)
end
