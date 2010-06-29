require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

Given /^I am not authenticated$/ do
  visit('/users/sign_out')
end

Given /^I have one\s+user "([^\"]*)" with password "([^\"]*)" and login "([^\"]*)"$/ do |email, password, login|
  User.new(:email => email,
           :login => login,
           :password => password,
           :password_confirmation => password).save!
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  login = 'Testing man'
  password = 'secretpass'

Given %{I have one user "#{email}" with password "#{password}" and login "#{login}"}
  And %{I go to login}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

When /^I want to edit my account$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the account initialization form$/ do
  pending # express the regexp above with the code you wish you had
end
