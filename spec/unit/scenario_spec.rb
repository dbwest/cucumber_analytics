require 'spec_helper'

SimpleCov.command_name('Scenario') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Scenario' do

  clazz = CucumberAnalytics::Scenario

  it_should_behave_like 'a feature element', clazz
  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'an inheriting element', clazz
  it_should_behave_like 'a containing element', clazz
  it_should_behave_like 'a tagged element', clazz
  it_should_behave_like 'a bare bones element', clazz
  it_should_behave_like 'a test element', clazz

  it 'can be parsed from stand alone text' do
    source = 'Scenario: '

    expect { clazz.new(source) }.to_not raise_error
  end

end
