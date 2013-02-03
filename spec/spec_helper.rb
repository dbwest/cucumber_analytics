require 'rspec'

require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'

require "#{File.dirname(__FILE__)}/../lib/cucumber_analytics"

CucumberAnalytics::Logging.set_log_level(Logger::FATAL)


DEFAULT_FEATURE_FILE_NAME = 'test_feature.feature'
DEFAULT_FILE_DIRECTORY = "#{File.dirname(__FILE__)}/temp_files"


RSpec.configure do |config|
  config.before(:all) do
    @default_feature_file_name = DEFAULT_FEATURE_FILE_NAME
    @default_file_directory = DEFAULT_FILE_DIRECTORY
  end

  config.before(:each) do
    FileUtils.mkdir(@default_file_directory)
  end

  config.after(:each) do
    FileUtils.remove_dir(@default_file_directory, true)
  end
end