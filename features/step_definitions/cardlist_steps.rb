When /^I add a card to the current cardlist$/ do
  click_button "add"
end

Given /^a cardlist named "([^"]*)"$/ do |title|
  @cardlist = Factory(:cardlist, :title => title )
  @user.cardlists << @cardlist
end
