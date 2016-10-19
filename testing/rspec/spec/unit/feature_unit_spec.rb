require 'spec_helper'

SimpleCov.command_name('Feature') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Feature, Unit' do

  clazz = CucumberAnalytics::Feature

  it_should_behave_like 'a feature element', clazz
  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'a containing element', clazz
  it_should_behave_like 'a tagged element', clazz
  it_should_behave_like 'a bare bones element', clazz
  it_should_behave_like 'a prepopulated element', clazz
  it_should_behave_like 'a sourced element', clazz
  it_should_behave_like 'a raw element', clazz

  before(:each) do
    @feature = clazz.new
  end

  it 'can be parsed from stand alone text' do
    source = 'Feature: test feature'

    expect { @element = clazz.new(source) }.to_not raise_error

    # Sanity check in case instantiation failed in a non-explosive manner
    expect(@element.name).to eq('test feature')
  end

  it 'will complain about unknown element types' do
    parsed_element = {'description' => '',
                      'elements' => [{'keyword' => 'Scenario', 'description' => ''},
                                     {'keyword' => 'New Type', 'description' => ''}]}

    expect { clazz.new(parsed_element) }.to raise_error(ArgumentError)
  end

  it 'has a background - #background' do
    expect(@feature.respond_to?(:background)).to be true
  end

  it 'can get and set its background - #background, #background=' do
    @feature.background = :some_background
    expect(@feature.background).to eq(:some_background)
    @feature.background = :some_other_background
    expect(@feature.background).to eq(:some_other_background)
  end

  it 'knows whether or not it presently has a background - has_background?' do
    @feature.background = :a_background
    expect(@feature).to have_background
    @feature.background = nil
    expect(@feature).to_not have_background
  end

  it 'has tests - #tests' do
    expect(@feature.respond_to?(:tests)).to be true
  end

  it 'can get and set its tests - #tests, #tests=' do
    @feature.tests = :some_tests
    expect(@feature.tests).to eq(:some_tests)
    @feature.tests = :some_other_tests
    expect(@feature.tests).to eq(:some_other_tests)
  end

  it 'knows how many tests it has - #test_count' do
    @feature.tests = []
    expect(@feature.test_count).to eq(0)
    @feature.tests = [:test_1, :test_2]
    expect(@feature.test_count).to eq(2)
  end

  it 'contains backgrounds and tests' do
    tests = [:test_1, :test_2]
    background = :a_background
    everything = [background] + tests

    @feature.background = background
    @feature.tests = tests

    expect(@feature.contains).to match_array(everything)
  end

  it 'contains a background only if one is present' do
    tests = [:test_1, :test_2]
    background = nil
    everything = tests

    @feature.background = background
    @feature.tests = tests

    expect(@feature.contains).to match_array(everything)
  end

  it 'starts with no background' do
    expect(@feature.background).to be_nil
  end

  it 'starts with no tests' do
    expect(@feature.tests).to eq([])
  end

  context 'feature output edge cases' do

    it 'is a String' do
      expect(@feature.to_s).to be_a(String)
    end

    it 'can output an empty feature' do
      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only a name' do
      @feature.name = 'a name'

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only a description' do
      @feature.description_text = 'a description'

      expect { @feature.to_s }.to_not raise_error
    end

    it 'can output a feature that has only a tags' do
      @feature.tags = ['a tag']

      expect { @feature.to_s }.to_not raise_error
    end

  end

end
