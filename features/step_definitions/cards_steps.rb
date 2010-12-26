Given /^a card(?: with title "([^"]*)")?$/ do |title|
  title.present? ? Factory.create(:card, :title => title) : Factory.create(:card)
end

When /^I edit the card with title "([^"]*)"$/ do |title|
  card = Card.find_by_title(title)
  visit edit_card_path(card)
end

Given /^some cards$/ do
  30.times { Factory(:card) }
  @cards = []
  @cards << Factory(:card, :title => "Darth Vader")
  @cards << Factory(:card, :title => "Darth Vader (V)")
  @cards << Factory(:card, :title => "Lord Vader")
end

When /^I search for "([^"]*)"$/ do |text|
  fill_in "search_box", :with => text
  click_button "Search"
end

Then /^I should see matching cards$/ do
  @cards.each do |card|
    And %{I should see "#{card.title}"}
  end
end
