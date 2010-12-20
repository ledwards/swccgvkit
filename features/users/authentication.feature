Feature: User authentication

	As a user
	I want to create an account and log in
	So that I can save my cardlists
	
	Scenario Outline: Creating a new account
	    Given I am not authenticated
	    When I go to register
	    And I fill in "user_email" with "jporkins@weightwatchers.com"
	    And I fill in "user_password" with "omnomnom"
	    And I fill in "user_password_confirmation" with "omnomnom"
	    And I press "Sign up"
	    Then I should see "Welcome"
	    
	Scenario Outline: Logging in
	    Given I am not authenticated
			And a user with email address "darthvader@galacticempire.gov" and password "padme4eva"
	    When I go to login
	    And I fill in "user_email" with "darthvader@galacticempire.gov"
	    And I fill in "user_password" with "padme4eva"
	    And I press "Sign in"
	    Then I should see "Welcome"