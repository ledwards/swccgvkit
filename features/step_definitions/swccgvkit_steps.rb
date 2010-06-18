Given /^that I am logged out$/ do
  if user_signed_in?
    @user.log_out
  end
end

When /^I create an account$/ do
  visit sign_up_path
  fill_in "Email address", :with => "darthvader@galacticempire.com"
  fill_in "Password", :with => "password"
  fill_in "Password confirmation", :with => "password"
  click_button "Join us!"
end
