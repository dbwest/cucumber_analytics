module Cucumber
  module Analytics
    class ParsedScenarioOutline

      attr_accessor :name
      attr_accessor :description
      attr_accessor :tags
      attr_accessor :steps
      attr_accessor :examples

      def initialize
        @name = ''
        @description = []
        @tags = []
        @steps = []
        @examples = []
      end

    end
  end
end
