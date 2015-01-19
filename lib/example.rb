#!/usr/bin/ruby
require 'fileutils'
require 'date'
require 'getoptlong'

include FileUtils

$debug = false # disable debug messages

# parse options into a hash
opt_list = [
  [ '--help',       '-h', GetoptLong::NO_ARGUMENT ],
  [ '--debug',      '-d', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--output',           GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--formatador', '-f', GetoptLong::OPTIONAL_ARGUMENT ],
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

# display a separator
def separator
  $stdout << "----------------------------\n"
end

def nl_added
  $stdout << "(newline added)\n"
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

# build a string of text to use in examples, based on arg list, if present.
text_list = (ARGV.empty?) ? %w[ A few default words from our sponsor. ] : ARGV

if opts[:output]
  separator

  $stdout << "$stdin, out & err can be concatenated to using the << operator."
  nl_added

  separator
  
  puts "puts separates its arguments w/ the input record separator ('$/', default: '\\n')"
  puts *text_list

  separator

  puts "print separates its arguments w/ the output field separator ('$,', default: nil)"
  print *text_list
  puts "Changing $, to ', ':"
  old_value = $,; $, = ", "
  print *text_list
  $, = old_value
  nl_added

  separator

end

if opts[:formatador]
  require 'formatador'
  #require '../../formatador/lib/formatador'

  def loop_color(index, bg: false)
    colors = %w[ red green yellow blue magenta purple cyan white
                 light_black light_red light_green light_yellow light_blue
                 light_magenta light_purple light_cyan black ]
    colors = colors.map { |color| "_#{color}_" } if bg

    "[#{colors[index % colors.length]}]"
  end

  def color_end
    "[/]"
  end

  # build a colorful tag line
  tag = "In vibrant living colors"
  in_living_color = tag.length.times.map { |i| "#{loop_color(i)}#{tag[i]}" }.join + color_end

  separator
  
  Formatador.display_line "#display_line displays a newline-terminated line, optionally #{in_living_color}"

  f = Formatador.new

  colored_list = text_list.length.times.map { |i| "#{loop_color(i)}#{text_list[i]}" }.join(' ') + color_end
  f.display_line *colored_list

  f.display_line "And"
  f.indent {
    f.display_line "with"
    f.indent {
      f.display_line "varying"
      f.indent {
        f.display_line "levels"
        f.indent {
          f.display_line "of"
          f.indent {
            f.display_line "indentation"
          }
        }
      }
    }
  }
  f.display_line

  f.display_line "#display displays a raw line, optionally #{in_living_color}"
  f.display *colored_list; nl_added

  f.display_line "the word 'indent' in square brackets will insert spaces equal to the current indent."
  indented_colored_list = colored_list.scan(/[\[\w\]\/]+/).map { |i| "[indent]#{colored_list[i]}" }.join(" ")
  f.display_line *indented_colored_list
  f.display *indented_colored_list; nl_added

  f.display_line "colors can also be specified for the background:"
  colored_list = text_list.length.times.map { |i| "#{loop_color(i, bg: true)}#{text_list[i]}" }.join(' ') + color_end
  f.display_line *colored_list

  f.display_line "You can also do Progress Bars..."
  total = 10
  pbar = Formatador::ProgressBar.new(total)
  total.times do |i|
    pbar.increment
    sleep 0.5/(i + 1)
  end

  f.display_line "And Tables..."
  f.display_table([opts])   # display opts hash 'as-is'
  f.display_table( opts.map  { |o,v| {option: "#{o}", value: "#{v}"}})  # reformat as "option/value"

  separator
end
