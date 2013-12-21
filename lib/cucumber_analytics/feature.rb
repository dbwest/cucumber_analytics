module CucumberAnalytics

  # A class modeling a Cucumber Feature.

  class Feature < FeatureElement

    include Taggable
    include Containing


    # The Background object contained by the Feature
    attr_accessor :background

    # The TestElement objects contained by the Feature
    attr_accessor :tests


    # Creates a new Feature object and, if *source* is provided, populates the
    # object.
    def initialize(source = nil)
      parsed_feature = process_source(source)

      super(parsed_feature)

      @tags = []
      @tag_elements = []
      @tests = []

      build_feature(parsed_feature) if parsed_feature
    end

    # Returns true if the feature contains a background, false otherwise.
    def has_background?
      !@background.nil?
    end

    # Returns the scenarios contained in the feature.
    def scenarios
      @tests.select { |test| test.is_a? Scenario }
    end

    # Returns the outlines contained in the feature.
    def outlines
      @tests.select { |test| test.is_a? Outline }
    end

    # Returns the number of scenarios contained in the feature.
    def scenario_count
      scenarios.count
    end

    # Returns the number of outlines contained in the feature.
    def outline_count
      outlines.count
    end

    # Returns the number of tests contained in the feature.
    def test_count
      @tests.count
    end

    # Returns the number of test cases contained in the feature.
    def test_case_count
      scenario_count + outlines.reduce(0) { |outline_sum, outline|
        outline_sum += outline.examples.reduce(0) { |example_sum, example|
          example_sum += example.rows.count
        }
      }
    end

    # Returns the immediate child elements of the feature (i.e. its Background,
    # Scenario, and Outline objects.
    def contains
      @background ? [@background] + @tests : @tests
    end


    # Returns gherkin representation of the feature.
    def to_s
      text = ''

      unless tag_elements.empty?
        tag_text = tag_elements.collect { |tag| tag.name }.join(' ')
        text << tag_text + "\n"
      end

      name_text = 'Feature:'
      name_text += " #{name}" unless name == ''
      text << name_text

      unless description.empty?
        description_text = "\n"
        description_text += description.collect { |line| "\n    #{line}" }.join
        text << description_text
      end

      if background
        background_text = "\n"
        background_text << background.to_s
        text << background_text.split("\n").collect { |line| line.empty? ? "\n" : "\n  #{line}" }.join
      end

      unless tests.empty?
        test_text = "\n"
        test_text += tests.collect { |test| test.to_s.split("\n").collect { |line| line.empty? ? "\n" : "\n  #{line}" }.join }.join("\n")
        text << test_text
      end

      text
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_feature(source)
        else
          source
      end
    end

    def parse_feature(source_text)
      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first
    end

    def build_feature(parsed_feature)
      populate_element_tags(parsed_feature)
      populate_feature_elements(parsed_feature)
    end

    def populate_feature_elements(parsed_feature)
      elements = parsed_feature['elements']

      if elements
        elements.each do |element|
          case element['keyword']
            when 'Scenario'
              @tests << build_child_element(Scenario, element)
            when 'Scenario Outline'
              @tests << build_child_element(Outline, element)
            when 'Background'
              @background = build_child_element(Background, element)
            else
              raise(ArgumentError, "Unknown keyword: #{element['keyword']}")
          end
        end
      end
    end

  end
end
