@javascript
Feature: User creates cardlists

	As a user
	I want to create a cardlist
	So that I can print multiple cards at once
	
	Scenario: Creating a new cardlist
		Given a logged in user
		And some cards
		And I am on the home page
		When I fill in "search_box" with "Vader"
		And I add a card to the current cardlist
		And I wait until I can see "#search_box"
		And I should see "Vader" within "#current_cardlist"