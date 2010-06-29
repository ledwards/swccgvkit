Feature: admin creates and edits cards

	As a user with role "admin"
	I want to create cards
	And edit cards
	So that the list of cards will always be up to date
	
	Scenario: create new cards
		Given I am logged in as a user with the "admin" role
		When I go to "new card"
		And I fill in "title" with "Huge Explosion"
		And I fill in "card_gametext" with "Kills everything on table."
		And I press "Create"
		Then I should see "Kills everything on table."
	
	Scenario: edit cards
		Given I am logged in as a user with the "admin" role
		And there is a card with title "Huge Explosion" and gametext "Kills a couple things."
		When I go to "edit card 1"
		And I fill in "card_gametext" with "Kills everything on table."
		And I press "Save"
		Then I should see "Kills everything on table."