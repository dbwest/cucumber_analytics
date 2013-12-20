module CucumberAnalytics

  # A class modeling the Doc String of a Step.

  class DocString

    include Raw
    include Nested


    # The content type associated with the doc string
    attr_accessor :content_type

    # The contents of the doc string
    attr_accessor :contents


    # Creates a new DocString object and, if *source* is provided, populates
    # the object.
    def initialize(source = nil)
      @contents = []

      parsed_doc_string = process_source(source)

      build_doc_string(parsed_doc_string) if parsed_doc_string
    end

    # Returns a gherkin representation of the doc string.
    def to_s
      text = '"""'
      text << " #{content_type}" if content_type
      text << "\n"
      text << contents.join("\n")

      text << "\n" + '"""'

      text
    end


    private


    def process_source(source)
      case
        when source.is_a?(String)
          parse_doc_string(source)
        else
          source
      end
    end

    def parse_doc_string(source_text)
      base_file_string = "Feature:\nScenario:\n* step\n"
      source_text = base_file_string + source_text

      parsed_file = Parsing::parse_text(source_text)

      parsed_file.first['elements'].first['steps'].first['doc_string']
    end

    def build_doc_string(doc_string)
      populate_content_type(doc_string)
      populate_contents(doc_string)
      populate_raw_element(doc_string)
    end

    def populate_content_type(doc_string)
      @content_type = doc_string['content_type'] == "" ? nil : doc_string['content_type']
    end

    def populate_contents(doc_string)
      @contents = doc_string['value'].split($/)
    end

  end
end
