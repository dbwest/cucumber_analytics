Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? keyword is "([^"]*)"$/ do |file, test, step, keyword|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = keyword
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].keyword

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? has the following block:$/ do |file, test, step, block|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = block.raw.flatten.collect do |cell_value|
    if cell_value.start_with? "'"
      cell_value.slice(1..cell_value.length - 2)
    else
      cell_value
    end
  end

  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.flatten

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? has no block$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = nil
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block

  actual.should == expected
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? text is "([^"]*)"$/ do |file, test, step, text|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = text
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].base

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? arguments are:$/ do |file, test, step, arguments|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = arguments.raw.flatten
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].arguments

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?test(?: "([^"]*)")? step(?: "([^"]*)")? has no arguments$/ do |file, test, step|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = []
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].arguments

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? has a "([^"]*)"$/ do |file, test, step, type|
  file ||= 1
  test ||= 1
  step ||= 1

  case type
    when 'doc string'
      expected = CucumberAnalytics::DocString
    when 'table'
      expected = CucumberAnalytics::Table
    else
      raise(ArgumentError, "Unknown block type: #{type}")
  end

  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].block.class

  actual.should == expected
end

Then /^(?:the )?(?:feature "([^"]*)" )?(?:test(?: "([^"]*)")? )?step(?: "([^"]*)")? source line is "([^"]*)"$/ do |file, test, step, line_number|
  file ||= 1
  test ||= 1
  step ||= 1

  expected = line_number.to_i
  actual = @parsed_files[file - 1].feature.tests[test - 1].steps[step - 1].source_line

  actual.should == expected
end
