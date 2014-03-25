
##
# Module used that allows to print warnings, errors, messages, failures and
# backtraces with colors in a simple way.

module SodaLogger

  # Default color constant
  DEFAULT = :default_color

  # Red color constant
  RED = :red_color

  # Green color constant
  GREEN = :green_color

  # Yellow color constant
  YELLOW = :yellow_color

  # Blue color constant
  BLUE = :blue_color

  # Magenta color constant
  MAGENTA = :magenta_color

  # Cyan color constant
  CYAN = :cyan_color

  # White color constant
  WHITE = :white_color

  COLORS = { DEFAULT => '39'
             RED => '31',
             GREEN => '32',
             YELLOW => '33',
             BLUE => '34',
             MAGENTA => '35',
             CYAN => '36',
             WHITE => '37' }

  # Call this method to print a yellow warning
  def self.warning(msg)
    self.message("WARNING: #{msg}", YELLOW)
  end

  # Call this method to print a red error
  def self.error(msg)
    self.message("ERROR: #{msg}", RED)
  end

  # Call this method to print a red error and exit.
  # Unlike self.error, the message is written to stderr, instead of stdout.
  def self.fail(msg, print_backtrace = true)
    self.message("\033[4mFAILURE:\033[0m\e[0;31m #{msg}", RED, $stderr)
    self.backtrace if print_backtrace
    exit(1)
  end

  # Call this method to print a green success message
  def self.success(msg)
    self.message("SUCCESS: #{msg}", GREEN)
  end

  # Call this method to print a backtrace of the program anytime.
  # Set stdout to true to print to stdout instead of stderr.
  def self.backtrace(stdout = false)
    out = (stdout && $stdout) || $stderr
    out.puts "Backtrace:"
    out.puts caller
  end

  # Call this method to print with a specified color or just a simple message
  # with the default color.
  def self.message(msg, color = DEFAULT, output = $stdout)
    raise ArgumentError, 'output must be $stdout or $stderr' unless
      output == $stdout || output == $stderr
    if COLORS.has_key?(color)
      output.puts "\e[0;" + COLORS[color] + "m#{msg}\e[0m"
    else
      output.puts msg
    end
  end
end
