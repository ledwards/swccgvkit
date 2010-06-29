require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

Given /^I am logged out$/ do
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

Given /^I am logged in as a user with the "([^"]*)" role$/ do |arg1|
  pending # express the regexp above with the code you wish you had
  # admin = User.new(:email => "testadmin", :password => "test", :password_confirmation => "test")
  # Cancan role syntax here
  # admin.save!
end

Given /^there is a card with title "([^"]*)" and gametext "([^"]*)"$/ do |arg1, arg2|
  card = Card.create(:title => arg1, :gametext => arg2, :expansion => "Hoth", :card_type => "Effect")
end
