When /^I wait until I can see "([^"]*)"$/ do |selector|
  find(selector)
end

Then /^I should see "([^"]*)" as the value of the "([^"]*)" input field$/ do |value, selector|
  find(selector).value.should =~ /#{value}/
end

And /^I wait for (\d+) seconds$/ do |s|
  sleep s.to_i
end

When /^I wait for the AJAX call to finish$/ do
  keep_looping = true
  while keep_looping do
    sleep 1
    begin
      count = page.evaluate_script('window.running_ajax_calls').to_i
      keep_looping = false if count == 0
    rescue => e
      if e.message.include? 'HTMLunitCorejsJavascript::Undefined'
        raise "For 'I wait for the AJAX call to finish' to work, please include cucumber.js after including jQuery."
      else
        raise e
      end
    end
  end
end

