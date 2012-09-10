module Cucumber
  module Analytics
    class ParsedFile

      attr_reader :feature

      def initialize(file_parsed)
        @file = file_parsed

        file_lines = []
        feature_lines = []
        background_lines = []

        File.open(@file, 'r') { |file| file_lines = file.readlines }
        file_lines.delete_if { |line| line =~ /^\s*#/ }
        file_lines.delete_if { |line| !(line =~ /\S/) }

        feature_start_line = file_lines.index { |line| line =~ /^s*Feature:/ }
        feature_lines.concat(file_lines.slice!(0..feature_start_line))

        feature_end_line = file_lines.index { |line| line =~ /^\s*(?:@|Background:|Scenario:|(?:Scenario Outline:))/ }
        feature_lines.concat(file_lines.slice!(0...feature_end_line))

        background_end_line = file_lines.index { |line| line =~ /^\s*(?:@|Scenario:|(?:Scenario Outline:))/ }
        background_lines.concat(file_lines.slice!(0...background_end_line))

        @feature = parse_feature(feature_lines)

        unless background_lines.empty?
          @feature.background = parse_background(background_lines)
        end

        parse_scenarios(file_lines)
      end

      def parse_feature(lines)
        feature = ParsedFeature.new

        feature
      end

      def parse_background(lines)
        background = ParsedBackground.new

        background.name.replace lines.first.match(/^\s*Background:(.*)/)[1].strip
        lines.shift

        until lines.first =~ /^\s*(?:(?:Given )|(?:When )|(?:Then )|(?:\* ))/
          background.description << lines.first.strip
          lines.shift
        end

        background.steps.concat lines.collect { |line| line.strip }

        background
      end

      def parse_scenario(lines)
        scenario = ParsedScenario.new

        lines.take_while { |line| !(line =~/^\s*Scenario:/) }.tap do |tag_lines|
          tag_lines.join(' ').delete(' ').split('@').each do |tag|
            scenario.tags << "@#{tag.strip}"
          end
        end
        scenario.tags.shift

        while lines.first =~ /^\s*@/
          lines.shift
        end

        scenario.name= lines.first.match(/^\s*Scenario:(.*)/)[1].strip

        lines.shift

        until lines.first =~ /^\s*(?:Given|When|Then|\*)/
          scenario.description << lines.first.strip
          lines.shift
        end

        scenario.steps.concat lines.collect { |line| line.strip }

        scenario
      end

      def parse_scenarios(lines)
        until lines.empty?
          current_scenario_line = lines.index { |line| line =~ /^\s*(?:Scenario:|(?:Scenario Outline:))/ }

          scenario_lines = lines.slice!(0..current_scenario_line)
          next_scenario_line = lines.index { |line| line =~ /^\s*(?:Scenario:|(?:Scenario Outline:))/ }

          if next_scenario_line.nil?
            scenario_lines.concat(lines.slice!(0..lines.count))
          else
            while  lines[next_scenario_line - 1] =~ /^\s*@/
              next_scenario_line -= 1
            end
            scenario_lines.concat(lines.slice!(0..next_scenario_line))
          end

          if scenario_lines[current_scenario_line] =~ /^\s*Scenario Outline:/
            next_scenario = parse_scenario_outline(scenario_lines)
          else
            next_scenario = parse_scenario(scenario_lines)
          end

          @feature.scenarios << next_scenario
        end
      end

    end
  end
end
