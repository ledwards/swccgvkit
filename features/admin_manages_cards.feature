Feature: admin manages cards

	As a user with role "admin"
	I want to create cards
	And edit cards
	So that the list of cards will always be up to date
	
	Scenario: admin creates new cards
		Given There is a role called "admin" 
		And There is a user with the email address "testadmin@swccgvkit.com" and the "admin" role
		When I go to login
		And I fill in "user_email" with "testadmin@swccgvkit.com"
		And I fill in "user_password" with "password"
		And I press "Sign in"
		And I go to new card
		And I fill in "card_title" with "Huge Explosion"
		And I fill in "card_card_type" with "Interrupt"
		And I fill in "card_expansion" with "Death Star III"		
		And I press "Create"
		Then I should see "Card was successfully created."
	
	Scenario: admin edits cards
		Given There is a role called "admin"
		And There is a user with the email address "testadmin@swccgvkit.com" and the "admin" role
		And there is a card with title "Huge Explosion"
		When I go to login
		And I fill in "user_email" with "testadmin@swccgvkit.com"
		And I fill in "user_password" with "password"
		And I press "Sign in"
		And I go to edit a card
		And I fill in "card_title" with "It's ok, I'm an admin"
		And I press "Save"
		Then I should see "Card was successfully updated."
		
	Scenario: user fails to edits cards
		Given There is a user with the email address "regularuser@swccgvkit.com"
		And there is a card with title "Huge Explosion"
		When I go to login
		And I fill in "user_email" with "regularuser@swccgvkit.com"
		And I fill in "user_password" with "password"
		And I press "Sign in"
		And I go to edit a card
		Then I should see "not authorized" #to fix, have CanCan::NotAuthorized redirect somewhere