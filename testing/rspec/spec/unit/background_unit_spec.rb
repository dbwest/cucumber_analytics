require 'spec_helper'

SimpleCov.command_name('Background') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Background, Unit' do

  clazz = CucumberAnalytics::Background

  it_should_behave_like 'a feature element', clazz
  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'a containing element', clazz
  it_should_behave_like 'a bare bones element', clazz
  it_should_behave_like 'a prepopulated element', clazz
  it_should_behave_like 'a test element', clazz
  it_should_behave_like 'a sourced element', clazz
  it_should_behave_like 'a raw element', clazz

  it 'can be parsed from stand alone text' do
    source = 'Background: test background'

    expect { @element = clazz.new(source) }.to_not raise_error

    # Sanity check in case instantiation failed in a non-explosive manner
    expect(@element.name).to eq('test background')
  end

  context 'background output edge cases' do

    before(:each) do
      @background = clazz.new
    end

    it 'is a String' do
      expect(@background.to_s).to be_a(String)
    end

    it 'can output an empty background' do
      expect { @background.to_s }.to_not raise_error
    end

    it 'can output a background that has only a name' do
      @background.name = 'a name'

      expect { @background.to_s }.to_not raise_error
    end

    it 'can output a background that has only a description' do
      @background.description_text = 'a description'

      expect { @background.to_s }.to_not raise_error
    end

  end

end
