#!/usr/bin/env ruby 

# Path settings 
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require './lib/findme'

# Default options 
options = {
    "socket" => [],
    "policy" => false,
    "timeout" => false, 
    "verbose" => nil,
    "logger" => nil,
    "output" => nil,
}

# Parsing Arguments

opt_parser = OptionParser.new do |opts|
    opts.banner =
        "Findme v#{FindMe::VERSION}\n\n Usage: findme [options]\n\n" 
    
    opts.on("-a", "--aws S3" , "S3 Bucket Name") do |target|
        options["target"] = target
    end

    opts.on("-f", "--file FILE", "File with list of targets") do |file|
        unless File.exists?(file)
            puts "File #{file} not found"
            exit
        end
        File.open(file).each do |line|
            options["target"] = line.strip
        end
    end

    opts.on("-T", "--timeout TIMEOUT", "Timeout for each request") do |timeout|
        options["timeout"] = timeout.to_i
    end

    opts.on("-L", "--logger [Log File Path]", "Enable logger") do |log_file|
        if log_file.nil?
            options["logger"] = Logger.new(STDERR)
        else
            options["logger"] = Logger.new $stdout.reopen(log_file, "w")
        end
    end

    opts.on("-O", "--from_json [JSON File Path]", "Load options from json file") do |file|
        unless File.exists?(file)
            puts "File #{file} not found"
            exit
        end
        file = open(file)
        json = file.read
        parsed_json = JSON.parse(json)
        parsed_json.each do |host|
            options["target"] = host
        end
    end

    opts.on("-o", "--output [Output File Path]", "Output results to file") do |file|
        options["output"] = file
    end

    opts.on("--output-type [json, yaml]", "Format to write stdout to json or yaml") do |output_type|
        options["output_type"] = output_type
    end

    opts.on("-v", "--verbose", "Verbose output") do |verbose|
        options["verbose"] = verbose
    end

    opts.on("-p", "--policy", "Show policy") do |policy|
        options["policy"] = policy
    end

    opts.on("--threads THREADS", "Number of threads") do |threads|
        options["threads"] = threads.to_i
    end

    opts.on("-h", "--help", "Show this help") do
        puts opts
        puts "\nExamples:"
        puts "  findme -a bucket"
        puts "  findme -f targets.txt"
        puts "  findme -T 10 -p"
        puts "  findme -O options.json"
        puts "  findme -o results.json"
        puts "  findme -o results.yaml"
        puts "  findme -o results.json -O options.json"
        puts "  findme -o results.json -O options.json -T 10"
        puts "  findme -o results.json -O options.json -T 10 -L log.txt"
        puts "  findme -o results.json -O options.json -T 10 -L log.txt -v"
        puts "  findme -o results.json -O options.json -T 10 -L log.txt -v -p"
        puts ""
        exit
    end
end

opt_parser.parse!

if options["target"].nil?
    puts (FindMe::Banner)
    puts opt_parser
    exit
end

options["target"] do |target|
    FindMe.new(target, options).run
end

class String
    def red; "\e[31m#{self}\e[0m" end
  end

scan_engine = FindMe::Scanner.new(options["target"])
scan_engine.scan
