module CucumberAnalytics

  # A class modeling a Cucumber Examples table.

  class Example < FeatureElement

    include Taggable

    # The argument rows in the example table
    attr_accessor :rows

    # The parameters for the example table
    attr_accessor :parameters


    # Creates a new Example object and, if *source* is provided,
    # populates the object.
    def initialize(source = nil)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      parsed_example = process_source(source)

      super(parsed_example)

      @tags = []
      @rows = []
      @parameters = []

      build_example(parsed_example) if parsed_example
    end

    # Adds a row to the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values which
    # will be assigned in order.
    def add_row(row)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      case
        when row.is_a?(Array)
          @rows << Hash[@parameters.zip(row.collect { |value| value.strip })]
        when row.is_a?(Hash)
          @rows << row.each_value { |value| value.strip! }
        else
          raise(ArgumentError, "Can only add row from a Hash or an Array but received #{row.class}")
      end
    end

    # Removes a row from the example table. The row can be given as a Hash of
    # parameters and their corresponding values or as an Array of values
    # which will be assigned in order.
    def remove_row(row)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      case
        when row.is_a?(Array)
          location = @rows.index { |row_hash| row_hash.values_at(*@parameters) == row.collect { |value| value.strip } }
        when row.is_a?(Hash)
          location = @rows.index { |row_hash| row_hash == row.each_value { |value| value.strip! } }
        else
          raise(ArgumentError, "Can only remove row from a Hash or an Array but received #{row.class}")
      end

      @rows.delete_at(location) if location
    end


    private


    def process_source(source)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      case
        when source.is_a?(String)
          parse_example(source)
        else
          source
      end
    end

    def parse_example(source_text)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      base_file_string = "Feature: Fake feature to parse\nScenario Outline:\n* fake step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first['elements'].first['examples'].first
    end

    def build_example(parsed_example)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      populate_element_tags(parsed_example)
      populate_example_parameters(parsed_example)
      populate_example_rows(parsed_example)
    end

    def populate_example_parameters(parsed_example)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      @parameters = parsed_example['rows'].first['cells']
    end

    def populate_example_rows(parsed_example)
      CucumberAnalytics::Logging.log_method("Example##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      parsed_example['rows'].shift
      parsed_example['rows'].each do |row|
        @rows << Hash[@parameters.zip(row['cells'])]
      end
    end

  end
end
