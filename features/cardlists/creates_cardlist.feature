@pending
Feature: User creates cardlists

	As a user
	I want to create a cardlist
	So that I can print multiple cards at once
	
	Scenario Outline: Creating a new cardlist
		Given a logged in user
		And some cards
		And I am on the builder page
		When I type "Vader" in the search box
		And I click add
		And I should see "New Cardlist" in the cardlist box
		Then I should see "Vader" in the cardlist box