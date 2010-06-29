Feature: user signs up

	As a user
	I want to create an account
	So that I can log in and save my decks
	
	Scenario Outline: Creating a new account
	    Given I am not authenticated
	    When I go to register
	    And I fill in "user_email" with "<email>"
	    And I fill in "user_password" with "<password>"
	    And I fill in "user_password_confirmation" with "<password>"
	    And I press "Sign up"
	    Then I should see "Welcome"

	    Examples:
	      | email           | password   |
	      | testing@man.net | secretpass |
	      | foo@bar.com     | fr33z3     |
	    
	Scenario Outline: Logging in
	    Given I am not authenticated
	    When I go to login
	    And I fill in "session_email" with "<email>"
	    And I fill in "session_password" with "<password>"
	    And I press "Sign in"
	    Then I should see "Welcome"

	    Examples:
	      | email               | password |
	      | admin@swccgvkit.com | password |