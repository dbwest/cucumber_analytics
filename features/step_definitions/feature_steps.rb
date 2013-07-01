Then /^(?:the )?feature(?: "([^"]*)")? is found to have the following properties:$/ do |file, properties|
  file ||= 1
  properties = properties.rows_hash

  properties.each do |property, expected_value|
    expected = expected_value
    actual = @parsed_files[file - 1].feature.send(property.to_sym).to_s

    assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
  end
end

Then /^the descriptive lines of feature "([^"]*)" are as follows:$/ do |file, lines|
  expected = lines.raw.flatten
  actual = @parsed_files[file - 1].feature.description

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^feature "([^"]*)" is found to have the following tags:$/ do |file, tags|
  expected = tags.raw.flatten
  actual = @parsed_files[file - 1].feature.tags

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

Then /^feature "([^"]*)" has no descriptive lines$/ do |file|
  assert @parsed_files[file - 1].feature.description == []
end

Then /^feature "([^"]*)" has no tags$/ do |file|
  assert @parsed_files[file - 1].feature.tags == []
end

When /^(?:the )?feature(?: "([^"]*)")? scenarios are as follows:$/ do |file, scenarios|
  file ||= 1

  actual_scenarios = @parsed_files[file - 1].feature.scenarios.collect { |scenario| scenario.name }

  assert actual_scenarios.flatten.sort == scenarios.raw.flatten.sort
end

When /^(?:the )?feature(?: "([^"]*)")? outlines are as follows:$/ do |file, outlines|
  file ||= 1

  actual_outlines = @parsed_files[file - 1].feature.outlines.collect { |outline| outline.name }

  expected = outlines.raw.flatten.sort
  actual = actual_outlines.flatten.sort

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^(?:the )?feature(?: "([^"]*)")? background is as follows:$/ do |file, background|
  file ||= 1

  @parsed_files[file - 1].feature.background.name.should  == background.raw.flatten.first
end

When /^feature "([^"]*)" has no scenarios$/ do |file|
  assert @parsed_files[file - 1].feature.scenarios == []
end

When /^feature "([^"]*)" has no outlines/ do |file|
  assert @parsed_files[file - 1].feature.outlines == []
end

When /^feature "([^"]*)" has no background/ do |file|
  assert @parsed_files[file - 1].feature.has_background? == false
end
