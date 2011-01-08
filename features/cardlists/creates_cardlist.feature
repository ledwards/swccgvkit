@javascript
Feature: User creates cardlists

	As a user
	I want to create a cardlist
	So that I can print multiple cards at once
	
	Scenario: Creating the first new cardlist
		Given a logged in user
		And some cards
		And I am on the home page
		When I fill in "search_box" with "Card"
		And I add a card to the current cardlist
		Then I should see "Card" within "#current_cardlist"
		
	Scenario: Creating a second cardlist
		Given a logged in user
		And some cards
		And a cardlist named "Old Cardlist"
		And I am on the home page
		When I fill in "search_box" with "Card"
		And I press "New"
		Then I should see "New Cardlist"
		And I add a card to the current cardlist
		Then I should see "Card" within "#current_cardlist"