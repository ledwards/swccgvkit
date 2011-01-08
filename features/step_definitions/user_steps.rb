Given /^I am logged out$/ do
  if user_signed_in?
    @user.log_out
  end
end

Given /^a logged in (admin|user)$/ do |role_name|
  role = Role.find_or_create_by_name(role_name)
  @user = Factory.create(:user)
  @user.roles << role
  visit new_user_session_path
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  click_button "Sign in"
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