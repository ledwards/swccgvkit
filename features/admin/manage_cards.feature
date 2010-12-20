Feature: Admin manages cards

	As an admin user
	I want to create and edit cards
	So that the list of cards will always be up to date
	
	Scenario: admin creates new cards
		Given a user with email address "testadmin@swccgvkit.com" and "admin" role
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
		Given a user with email address "testadmin@swccgvkit.com" and "admin" role
		And a card with title "Huge Explosion"
		When I go to login
		And I fill in "user_email" with "testadmin@swccgvkit.com"
		And I fill in "user_password" with "password"
		And I press "Sign in"
		And I edit the card with title "Huge Explosion"
		And I fill in "card_title" with "It's ok, I'm an admin"
		And I press "Save"
		Then I should see "It's ok, I'm an admin"
		
	Scenario: user fails to edits cards
		Given a user with email address "regularuser@swccgvkit.com"
		And a card with title "Huge Explosion"
		When I go to login
		And I fill in "user_email" with "regularuser@swccgvkit.com"
		And I fill in "user_password" with "password"
		And I press "Sign in"
		And I edit the card with title "Huge Explosion"
		Then I should see "not authorized"
	
	Scenario: admin sees a list of cards with missing images
		Given a user with email address "testadmin@swccgvkit.com" and "admin" role
		And a card with title "Huge Explosion"
		When I go to login
		And I fill in "user_email" with "testadmin@swccgvkit.com"
		And I fill in "user_password" with "password"
		And I press "Sign in"
		And I go to the cards page
		And I follow "Show cards with missing images"
		Then I should see "Huge Explosion"