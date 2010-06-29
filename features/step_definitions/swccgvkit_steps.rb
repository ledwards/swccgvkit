require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

Given /^that I am logged out$/ do
  if user_signed_in?
    @user.log_out
  end
end

Given /^there is a user with email address "([^"]*)" and password "([^"]*)"$/ do |arg1, arg2|
  User.create(:email => arg1, :password => arg2, :password_confirmation => arg2)
end

When /^I create an account$/ do
  visit sign_up_path
  fill_in "Email address", :with => "darthvader@galacticempire.com"
  fill_in "Password", :with => "password"
  fill_in "Password confirmation", :with => "password"
  click_button "Join us!"
end
