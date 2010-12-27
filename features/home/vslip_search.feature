Feature: User searches for virtual cards on 

	As a user
	I want to search and browse cards
	So that I can find out information about cards in the database
	
	Scenario: User searches cards index
		Given a logged in user
		And some cards
		When I go to the cards page
		And I search for "Vader"
		Then I should see matching cards