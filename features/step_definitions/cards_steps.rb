Given /^a card$/ do
  Factory.create(:card)
end

Given /^a card with ([^"]*) "([^"]*)"$/ do |attr, val|
  Factory.create(:card, attr.gsub(" ", "_").to_sym => val)
end

Given /^a card with title "([^"]*)" and no vslip image$/ do |title|
  Factory.create(:card, :title => title, :vslip_image_file_name => nil)
end

When /^I edit the card with title "([^"]*)"$/ do |title|
  card = Card.find_by_title(title)
  visit edit_card_path(card.id)
end

When /^I search for "([^"]*)"$/ do |text|
  fill_in "search_box", :with => text
  click_button "Search"
end

Given /^cards with the following attributes:$/ do |table|
  table.hashes.each do |attrs|
    Factory.create(:card, attrs)
  end
end

