module Sodascript

  ##
  # Include JavaScript representation

  class Include

    # Name of the js file to be included in the output file
    attr_reader :name

    ##
    # Creates a new Include given a file, checks if the file exists in the cwd

    def initialize(name)
      @name = name
      @data = File.open("#{Dir.pwd}/#{@name}.js")
      @file_not_found = false
    rescue
      @file_not_found = true
    end

    ##
    # Perform code generation for the include statement. If the file doesn't
    # exist, output a Warning message

    def to_s
      if @file_not_found
        SodaLogger.warning("Include #{@name}.js wasn't found on #{Dir.pwd}")
        "#{Indentation.get}// File #{@name} not found"
      else
        @data.map { |x| "#{Indentation.get}#{x}" }.join
      end
    end
  end
end
