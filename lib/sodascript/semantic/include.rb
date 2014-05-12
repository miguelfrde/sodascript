module Sodascript
  class Include
    attr_reader :name

    def initialize(name)
      @name = name
      @data = File.open("#{Dir.pwd}/#{@name}.js")
      @file_not_found = false
    rescue
      @file_not_found = true
    end

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
