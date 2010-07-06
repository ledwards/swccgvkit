Feature: admin manages cards

	As a user with role "admin"
	I want to create cards
	And edit cards
	So that the list of cards will always be up to date
	
	Scenario: create new cards
		Given There is a role called "admin" 
		And I am logged in as a user with the "admin" role
		When I go to new card
		And I fill in "card_title" with "Huge Explosion"
		And I fill in "card_card_type" with "Interrupt"
		And I fill in "card_expansion" with "Death Star III"		
		And I press "Create"
		Then I should see "Card was successfully created."
	
	Scenario: edit cards
		Given There is a role called "admin"
		And I am logged in as a user with the "admin" role
		And there is a card with title "Huge Explosion"
		When I go to edit card 1
		And show me the page
		And I fill in "card_expansion" with "Death Star IV"
		And I press "Save"
		Then I should see "Card was successfully updated."