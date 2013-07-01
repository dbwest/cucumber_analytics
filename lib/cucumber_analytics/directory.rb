module CucumberAnalytics

  # A class modeling a directory containing .feature files.

  class Directory

    include Containing


    # The FeatureFile objects contained by the Directory
    attr_accessor :feature_files

    # The Directory objects contained by the Directory
    attr_accessor :directories

    # The parent object that contains *self*
    attr_accessor :parent_element


    # Creates a new Directory object and, if *directory_parsed* is provided,
    # populates the object.
    def initialize(directory_parsed = nil)
      @directory = directory_parsed

      @feature_files = []
      @directories = []

      if directory_parsed
        raise(ArgumentError, "Unknown directory: #{directory_parsed.inspect}") unless File.exists?(directory_parsed)
        build_directory
      end
    end

    # Returns the name of the directory.
    def name
      File.basename(@directory.gsub('\\', '/'))
    end

    # Returns the path of the directory.
    def path
      @directory
    end

    # Returns the number of sub-directories contained in the directory.
    def directory_count
      @directories.count
    end

    # Returns the number of features files contained in the directory.
    def feature_file_count
      @feature_files.count
    end

    # Returns the immediate child elements of the directory (i.e. its Directory
    # and FeatureFile objects).
    def contains
      @feature_files + @directories
    end


    private


    def build_directory
      entries = Dir.entries(@directory)
      entries.delete '.'
      entries.delete '..'

      entries.each do |entry|
        entry = "#{@directory}/#{entry}"

        case
          when File.directory?(entry)
            @directories << build_child_element(Directory, entry)
          when entry =~ /\.feature$/
            @feature_files << build_child_element(FeatureFile, entry)
        end
      end

    end

  end
end