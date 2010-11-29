require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

Given /^I am logged out$/ do
  if user_signed_in?
    @user.log_out
  end
end

Given /^a logged in (admin|user)$/ do |role|
  role = Role.find_or_create_by_name(role)
  user = Factory.create(:user)
  user.roles << role
  visit log_in_path
  fill_in "Email address", :with => user.email
  fill_in "Password", :with => user.password
  press sign_in
end

Given /^a card(?: with title "([^"]*)")?$/ do |title|
  title.present? ? Factory.create(:card, :title => title) : Factory.create(:card)
end

Given /^a user with email address "([^"]*)"$/ do |email|
  user = Factory.create(:user, :email => email)
end

Given /^a user with email address "([^"]*)" and password "([^"]*)"$/ do |email, password|
  Factory(:user, :email => email, :password => password, :password_confirmation => password)
end

Given /^a user with email address "([^"]*)" and "([^"]*)" role$/ do |email, role_name|
  role = Role.find_or_create_by_name(role_name)
  user = Factory.create(:user, :email => email)
  user.roles << role
end

When /^I create an account$/ do
  visit sign_up_path
  fill_in "Email address", :with => "darthvader@galacticempire.com"
  fill_in "Password", :with => "password"
  fill_in "Password confirmation", :with => "password"
  click_button "Join us!"
end

Given /^a role called "([^"]*)"$/ do |role_name|
  role = Role.find_or_create_by_name(role_name)
  role.save!
end

When /^I edit the card with title "([^"]*)"$/ do |title|
  card = Card.find_by_title(title)
  visit edit_card_path(card)
end