require 'spec_helper'

shared_examples_for 'a test element' do |clazz|

  before(:each) do
    @element = clazz.new
  end

  it 'has steps - #steps' do
    @element.should respond_to(:steps)
  end

  it 'can get and set its steps - #steps, #steps=' do
    @element.steps = :some_steps
    @element.steps.should == :some_steps
    @element.steps = :some_other_steps
    @element.steps.should == :some_other_steps
  end

  it 'starts with no steps' do
    @element.steps.should == []
  end

  it 'contains steps - #contains' do
    steps = [:step_1, :step_2, :step_3]
    @element.steps = steps

    steps.each { |step| @element.contains.should include(step) }
  end

end
