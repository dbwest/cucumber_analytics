require "#{File.dirname(__FILE__)}/../spec_helper"

SimpleCov.command_name('Sourceable') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Sourceable, Unit' do

  nodule = CucumberAnalytics::Sourceable

  before(:each) do
    @element = Object.new.extend(nodule)
  end

  it 'has a source line - #source_line' do
    expect(@element.respond_to?(:source_line)).to be true
  end

end
