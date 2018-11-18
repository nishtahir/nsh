require "file_utils"
require "readline"
require "process"
require "./version"

module Nsh
  loop do
    prompt = ENV["PROMPT"] ||= ">"
    raw_input = Readline.readline("#{FileUtils.pwd}:#{prompt} ", true)
    exit(0) if raw_input.nil?

    args = raw_input.strip.split(/\s/).reverse

    command = args.pop
    case command
    when "q", "quit"
      exit(0)
    when "cd"
      if dest = args.pop?
        cd dest
      end
    when "h", "help"
      help
    when "setenv"
      setenv args.pop
    else
      exec command, args
    end
  end
end

def cd(dest : String)
  if File.directory?(dest)
    FileUtils.cd(dest)
  else
    puts "No such directory #{dest}"
  end
end

def exec(command : String, args : Array(String))
  if !command.empty?
    Process.run(command, args, input: STDIN, output: STDOUT)
  end
rescue ex
  puts ex.message
end

def help
  puts "Nish's NSH. Version #{Nsh::VERSION}"
  puts "Type a command and hit enter.\n\n"
end

def setenv(args)
  key, value = args.split("=")
  ENV[key] = value
end