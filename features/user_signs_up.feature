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
	      | foo@bar.com     | bazbazbaz  |
	    
	Scenario Outline: Logging in
	    Given I am not authenticated
			And there is a user with email address "<email>" and password "<password>"
	    When I go to login
	    And I fill in "user_email" with "<email>"
	    And I fill in "user_password" with "<password>"
	    And I press "Sign in"
	    Then I should see "Welcome"

	    Examples:
	      | email       | password  |
	      | foo@bar.com | bazbazbaz |