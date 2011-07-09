Given /^a card$/ do
  Factory.create(:card)
end

Given /^a card with ([^"]*) "([^"]*)"$/ do |attr, val|
  Factory.create(:card, attr.gsub(" ", "_").to_sym => val)
end

When /^I edit the card with title "([^"]*)"$/ do |title|
  card = Card.find_by_title(title)
  visit edit_card_path(card.id)
end

Given /^some cards$/ do
  30.times { Factory.create(:card) }
  @cards = []
  @cards << Factory.create(:card, :title => "Darth Vader")
  @cards << Factory.create(:card, :title => "Darth Vader (V)")
  @cards << Factory.create(:card, :title => "Lord Vader")
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
