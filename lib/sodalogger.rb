
##
# Module used that allows to print warnings, errors, messages, failures and
# backtraces with colors in a simple way.

module SodaLogger


  # Red color constant
  RED = 31

  # Green color constant
  GREEN = 32

  # Brown color constant
  BROWN = 33

  # Blue color constant
  BLUE = 34

  # Magenta color constant
  MAGENTA = 35

  # Cyan color constant
  CYAN = 36

  # Gray color constant
  GRAY = 37

  # Default color constant
  DEFAULT = 39

  # Dark gray color constant
  DARK_GRAY = 40

  # Light red color constant
  LIGHT_RED = 41

  # Light green color constant
  LIGHT_GREEN = 42

  # Yellow color constant
  YELLOW = 43

  # Light blue color constant
  LIGHT_BLUE = 44

  # Light purple color constant
  LIGHT_PURPLE = 45

  # Light cyan color constant
  LIGHT_CYAN = 46

  # White color constant
  WHITE = 47

  # Call this method to print a yellow warning
  def self.warning(msg)
    self.message("WARNING: #{msg}", YELLOW)
  end

  # Call this method to print a red error
  def self.error(msg)
    self.message("ERROR: #{msg}", RED)
    ENV['SODA_ERROR'] = '1'
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
    if 31 <= color && color <= 37
      output.puts "\e[0;#{color}m#{msg}\e[0m"
    elsif 41 <= color && color <= 47
      output.puts "\e[1;#{color - 10}m#{msg}\e[0m"
    else
      output.puts msg
    end
  end
end
