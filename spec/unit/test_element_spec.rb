require 'spec_helper'

SimpleCov.command_name('TestElement') unless RUBY_VERSION.to_s < '1.9.0'

describe 'TestElement, Unit' do

  clazz = CucumberAnalytics::TestElement

  it_should_behave_like 'a test element', clazz
  it_should_behave_like 'a feature element', clazz
  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'a prepopulated element', clazz
  it_should_behave_like 'a bare bones element', clazz


  before(:each) do
    @element = clazz.new
  end

  it 'contains only steps - #contains' do
    steps = [:step_1, :step_2, :step_3]
    @element.steps = steps

    @element.contains.should =~ steps
  end

  it 'can determine its equality with another TestElement - #==' do
    element_1 = clazz.new
    element_2 = clazz.new
    element_3 = clazz.new

    element_1.steps = :some_steps
    element_2.steps = :some_steps
    element_3.steps = :some_other_steps

    (element_1 == element_2).should be_true
    (element_1 == element_3).should be_false
  end

end
