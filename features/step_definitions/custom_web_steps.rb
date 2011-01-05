When /^I wait until I can see "([^"]*)"$/ do |selector|
  find(selector)
end

Then /^I should see "([^"]*)" as the value of the "([^"]*)" input field$/ do |value, selector|
  find(selector).value.should =~ /#{value}/
end
