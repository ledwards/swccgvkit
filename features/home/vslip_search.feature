Feature: User searches for virtual cards on 

	As a user
	I want to search and browse vslips
	So that I can pick vslips to add to my cardlists
	
	Scenario: User searches cards index
		Given a logged in user
		And some cards
		When I go to the home page
		And I search for "Vader"
		Then I should see matching cards