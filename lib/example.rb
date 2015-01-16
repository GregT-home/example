#!/usr/bin/ruby
require 'fileutils'
require 'date'
require 'getoptlong'

include FileUtils

$debug = false # disable debug messages

# parse options into a hash
opt_list = [
  [ '--help',        '-h', GetoptLong::NO_ARGUMENT ],
  [ '--debug',       '-e', GetoptLong::OPTIONAL_ARGUMENT ],
]
usage_msg=<<-EOF.lstrip.split("\n")
    ?Usage: #{File.basename $0} [arg] [--options]

     options: 
       #{opt_list.map { |opt| "#{opt[0]} (#{opt[1]})" }.join("\n       ")}
 
     defaults:
       none currently

     EOF

# debug logger
def dlog(*args)
  $stderr.puts args if $debug
end

# Put array of messages to stderr
def err_usage(*msgs)
  $stderr.puts msgs
  exit!(false)
end

# convert getoptlog return value to an option hash
def getoptlong_to_hash(list)
  opts = {}
  list.each { |name, val| opts.store(name.sub(/^-*/,"").to_sym, val) }
  opts
end

#-------------------------------------------------
# begin command line processing

opts = getoptlong_to_hash(GetoptLong.new(*opt_list))

if opts[:debug]
   $debug = true
   debug_level = opts[:debug].to_i
   dlog "Debugging is enabled."
end

#-------------------------------------------------
# debug: show current option situation

dlog("options we see:")
opts.each { |key, val| dlog "  opts[#{key}] = #{opts[key]}" }

# reminder of how argv works so we can incorporate it into the command operation later
dlog "\n#{File.basename $0} was passed:",
     (ARGV.empty?) ? "  <no args>" : ARGV.map.with_index { |value, i| "  arg #{i}: #{value}" },
     ""

dlog "Ready to roll."

#-------------------------------------------------

err_usage(usage_msg) if opts[:help] || opts.empty?

puts "Write a program to process these arguments: #{ARGV}" 
