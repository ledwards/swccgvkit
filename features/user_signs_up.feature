Feature: user signs up

	As a user
	I want to create an account
	So that I can log in and save my decks
	
	Scenario: create user account
		Given that I am logged out
		When I create an account
		Then I should see "Welcome"