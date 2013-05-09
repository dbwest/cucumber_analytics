require 'spec_helper'

SimpleCov.command_name('World') unless RUBY_VERSION.to_s < '1.9.0'

describe 'World' do

  before(:each) do
    @world = CucumberAnalytics::World
    @world.loaded_step_patterns.clear
  end

  context 'collecting stuff' do

    before(:each) do
      @patterns = [/a defined step/, /another defined step/]
      @defined_steps = [CucumberAnalytics::Step.new('* a defined step'), CucumberAnalytics::Step.new('* another defined step')]
      @undefined_steps = [CucumberAnalytics::Step.new('* an undefined step'), CucumberAnalytics::Step.new('* another undefined step')]

      @patterns.each do |pattern|
        @world.load_step_pattern(pattern)
      end
    end

    it 'can collect defined steps from containers' do
      nested_container = double(:steps => @defined_steps)
      container = double(:steps => @undefined_steps, :contains => [nested_container])

      @defined_steps.should =~ @world.defined_steps_in(container)
    end

    it 'can collect undefined steps from containers' do
      nested_container = double(:steps => @defined_steps)
      container = double(:steps => @undefined_steps, :contains => [nested_container])

      @undefined_steps.should =~ @world.undefined_steps_in(container)
    end

  end

end
