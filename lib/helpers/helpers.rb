module Helpers
  class Debug
    attr_accessor :debug_level

    def initialize(debug_level = 0)
      $stderr.puts "Debug.new called with argument of #{debug_level}"
      @debug_level = debug_level
    end

    def level(level)
      @debug_level =  level
      puts "Debugging level is #{level}"
    end

    def puts(*args)
      $stderr.puts args.map { |a| "dbg: #{a}" } if debug
    end

  # display current option situation
  def arg_summary(opts)
    puts "", "options we see:"
    opts.each do |key, val|
      puts "  opts[#{key}] = #{opts[key]}"
    end

    # reminder of how argv works so we can incorporate it into the command operation later
    puts "",
      "#{File.basename $0} was passed:",
      (ARGV.empty?) ? "  <no args>" : ARGV.map.with_index { |value, i| "  arg #{i}: #{value}" },
      ""
  end
  private

  def debug
    debug_level > 0
  end
  end

  def separator
    $stdout << "----------------------------\n"
  end

  def nl_added
    $stdout << "(newline added)\n"
  end

  # convert getoptlog return value to an option hash
  def getoptlong_to_hash(list)
    options = {}
    list.each { |name, val| options.store(name.sub(/^-*/,"").to_sym, val) }
    options
  end
end
