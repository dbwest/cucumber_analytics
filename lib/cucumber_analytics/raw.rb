module CucumberAnalytics

  # A mix-in module containing methods used by elements that store their
  # underlying implementation

  module Raw

    # The raw representation of the element (i.e. the output of the gherkin gem)
    attr_accessor :raw_element


    private


    def populate_raw_element(parsed_element)
      @raw_element = parsed_element
    end

  end
end
