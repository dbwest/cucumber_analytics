module CucumberAnalytics

  # A class modeling a Cucumber Scenario Outline.

  class Outline < TestElement

    include Taggable
    include Containing


    # The Example objects contained by the Outline
    attr_accessor :examples


    # Creates a new Outline object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      CucumberAnalytics::Logging.log_method("#{self.class}##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      parsed_outline = process_source(source)

      super(parsed_outline)

      @tags = []
      @examples = []

      build_outline(parsed_outline) if parsed_outline
    end

    # Returns the immediate child elements of the outline (i.e. its Example
    # objects.
    def contains
      CucumberAnalytics::Logging.log_method("#{self.class}##{__method__}")

      @examples + @steps
    end


    private


    def build_outline(parsed_outline)
      CucumberAnalytics::Logging.log_method("#{self.class}##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      populate_element_tags(parsed_outline)
      populate_outline_examples(parsed_outline['examples']) if parsed_outline['examples']
    end

    def populate_outline_examples(parsed_examples)
      CucumberAnalytics::Logging.log_method("#{self.class}##{__method__}", method(__method__).parameters.map { |arg| "#{arg[1].to_s} = #{eval arg[1].to_s}" })

      parsed_examples.each do |example|
        @examples << build_child_element(Example, example)
      end
    end

  end
end
