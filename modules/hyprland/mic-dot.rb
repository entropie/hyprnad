# frozen_string_literal: true

require "json"

SOURCE = "alsa_input.usb-Logitech_PRO_X_Wireless_Gaming_Headset-00.mono-fallback"
PORT = "#{SOURCE}:capture_MONO"

def read_command(*args)
  output = IO.popen(args, &:read)
  output if $?.success?
rescue SystemCallError
  nil
end

def headset_available?
  result = read_command("device-battery", "headset")
  result && !JSON.parse(result).fetch("text").empty?
rescue JSON::ParserError, KeyError
  false
end

def mic_state(available)
  return ["off", "Headset unavailable"] unless available

  case read_command("pactl", "get-source-mute", SOURCE)&.strip
  when "Mute: yes" then return ["off", "Microphone muted"]
  when "Mute: no"  # Check capture links below.
  else return ["off", "Microphone unavailable"]
  end

  links = read_command("pw-link", "-l")
  return ["off", "PipeWire unavailable"] unless links

  # Inspect only outgoing links from the headset microphone.
  lines = links.lines(chomp: true)
  port_index = lines.index(PORT)
  if port_index
    targets = lines.drop(port_index + 1).take_while { |line| line.start_with?(" ", "\t") }
    return ["recording", "Microphone in use"] if targets.any? { |line| line.strip.start_with?("|-> ") && line.strip != "|-> PulseAudio Volume Control:input_MONO" }
  end

  ["ready", "Microphone ready"]
end

ENV["LC_ALL"] = "C"
$stdout.sync = true
previous = nil
next_probe = 0
available = false

loop do
  now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  if now >= next_probe
    available = headset_available?
    next_probe = now + 10
  end

  state = mic_state(available)
  unless state == previous
    puts JSON.generate(text: "●", class: state.first, tooltip: state.last)
    previous = state
  end
  sleep 1
end
