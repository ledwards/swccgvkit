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

Given /^There is a role called "([^"]*)"$/ do |arg1|
  role = Role.find_by_name(arg1) || Role.new(:name => arg1)
  role.save!
end

Given /^I am logged in as a user with the "([^"]*)" role$/ do |arg1|
  admin = User.new(:email => "testadmin@swccgvkit.com", :password => "test", :password_confirmation => "test")
  admin_role = Role.find_by_name(arg1)
  admin.roles << admin_role
  admin.save!
end

Given /^there is a card with title "([^"]*)"$/ do |arg1|
  card = Card.create(:title => arg1, :gametext => "", :expansion => "Hoth", :card_type => "Effect")
end
