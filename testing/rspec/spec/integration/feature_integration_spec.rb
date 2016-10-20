require "#{File.dirname(__FILE__)}/../spec_helper"

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Integration' do

  clazz = CucumberAnalytics::Feature

  before(:each) do
    @feature = clazz.new
  end

  it 'properly sets its child elements' do
    source = ['@a_tag',
              'Feature: Test feature',
              '  Background: Test background',
              '  Scenario: Test scenario',
              '  Scenario Outline: Test outline']
    source = source.join("\n")


    feature = CucumberAnalytics::Feature.new(source)
    background = feature.background
    scenario = feature.tests[0]
    outline = feature.tests[1]
    tag = feature.tag_elements[0]


    expect(outline.parent_element).to be(feature)
    expect(scenario.parent_element).to be(feature)
    expect(background.parent_element).to be(feature)
    expect(tag.parent_element).to be(feature)
  end

  it 'can distinguish scenarios from outlines - #scenarios, #outlines' do
    scenarios = [CucumberAnalytics::Scenario.new('Scenario: 1'), CucumberAnalytics::Scenario.new('Scenario: 2')]
    outlines = [CucumberAnalytics::Outline.new('Scenario Outline: 1'), CucumberAnalytics::Outline.new('Scenario Outline: 2')]

    @feature.tests = scenarios + outlines

    expect(@feature.scenarios).to match_array(scenarios)
    expect(@feature.outlines).to match_array(outlines)
  end

  it 'knows how many scenarios it has - #scenario_count' do
    scenarios = [CucumberAnalytics::Scenario.new('Scenario: 1'), CucumberAnalytics::Scenario.new('Scenario: 2')]
    outlines = [CucumberAnalytics::Outline.new('Scenario Outline: 1')]

    @feature.tests = []
    expect(@feature.scenario_count).to eq(0)

    @feature.tests = scenarios + outlines
    expect(@feature.scenario_count).to eq(2)
  end

  it 'knows how many outlines it has - #outline_count' do
    scenarios = [CucumberAnalytics::Scenario.new('Scenario: 1')]
    outlines = [CucumberAnalytics::Outline.new('Scenario Outline: 1'), CucumberAnalytics::Outline.new('Scenario Outline: 2')]

    @feature.tests = []
    expect(@feature.outline_count).to eq(0)

    @feature.tests = scenarios + outlines
    expect(@feature.outline_count).to eq(2)
  end

  it 'knows how many test cases it has - #test_case_count' do
    source_1 = ['Feature: Test feature']
    source_1 = source_1.join("\n")

    source_2 = ['Feature: Test feature',
                '  Scenario: Test scenario',
                '  Scenario Outline: Test outline',
                '    * a step',
                '  Examples: Test examples',
                '    |param|',
                '    |value_1|',
                '    |value_2|']
    source_2 = source_2.join("\n")

    feature_1 = CucumberAnalytics::Feature.new(source_1)
    feature_2 = CucumberAnalytics::Feature.new(source_2)


    expect(feature_1.test_case_count).to eq(0)
    expect(feature_2.test_case_count).to eq(3)
  end


  context 'getting stuff' do

    before(:each) do
      source = ['Feature: Test feature']
      source = source.join("\n")

      file_path = "#{@default_file_directory}/feature_test_file.feature"
      File.open(file_path, 'w') { |file| file.write(source) }

      @directory = CucumberAnalytics::Directory.new(@default_file_directory)
      @feature = @directory.feature_files.first.features.first
    end


    it 'can get its directory' do
      directory = @feature.get_ancestor(:directory)

      expect(directory).to be(@directory)
    end

    it 'can get its feature file' do
      feature_file = @feature.get_ancestor(:feature_file)

      expect(feature_file).to be(@directory.feature_files.first)
    end

    it 'returns nil if it does not have the requested type of ancestor' do
      test = @feature.get_ancestor(:test)

      expect(test).to be_nil
    end

  end

  context 'feature output edge cases' do

    it 'can output a feature that has only a tag elements' do
      @feature.tag_elements = [CucumberAnalytics::Tag.new]

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only a background' do
      @feature.background = [CucumberAnalytics::Background.new]

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only scenarios' do
      @feature.tests = [CucumberAnalytics::Scenario.new]

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only outlines' do
      @feature.tests = [CucumberAnalytics::Outline.new]

      expect { @feature.to_s }.to_not raise_error
    end

  end

end
