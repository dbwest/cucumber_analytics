Given /^the following(?: feature)? file(?: "([^"]*)")?:$/ do |file_name, file_text|
  @test_directory ||= @default_file_directory
  file_name ||= @default_feature_file_name

  File.open("#{@test_directory}/#{file_name}", 'w') { |file|
    file.write(file_text.gsub(/-"-"-"-/, '"""'))
  }
end

When /^the file(?: "([^"]*)")? is read$/ do |file_name|
  @parsed_files ||= []
  @test_directory ||= @default_file_directory
  file_name ||= @default_feature_file_name

  @parsed_files << Cucumber::Analytics::ParsedFile.new("#{@test_directory}/#{file_name}")
end

When /^the step definition file "([^"]*)" is read$/ do |file_name|
  @test_directory ||= @default_file_directory
  file_name ||= @default_step_file_name

  Cucumber::Analytics::World.load_step_file("#{@test_directory}/#{file_name}")
end

When /^parameter delimiters of "([^"]*)" and "([^"]*)"$/ do |left_delimiter, right_delimiter|
  @left_delimiter = left_delimiter
  @right_delimiter = right_delimiter
end

Given /^a directory "([^"]*)"$/ do |directory_name|
  @test_directory = "#{@default_file_directory}/#{directory_name}"

  FileUtils.mkdir(@test_directory) unless File.exists?(@test_directory)
end

When /^the directory(?: "([^"]*)")? is read$/ do |directory_name|
  @parsed_directories ||= []
  @test_directory = "#{@default_file_directory}/#{directory_name}" if directory_name

  @parsed_directories << Cucumber::Analytics::ParsedDirectory.new(@test_directory)
end

When /^the following step definition file(?: "([^"]*)")?:$/ do |file_name, file_text|
  @test_directory ||= @default_file_directory
  file_name ||= @default_step_file_name

  File.open("#{@test_directory}/#{file_name}", 'w') { |file|
    file.write(file_text)
  }
end
