Feature: User authentication

	As a user
	I want to create an account and log in
	So that I can save my cardlists

  Scenario: Creating a new account
    When I go to the new user registration page
    And I fill in "Email" with "jporkins@weightwatchers.com"
    And I fill in "Password" with "omnomnom"
    And I fill in "Password confirmation" with "omnomnom"
    And I press "Sign up"
    Then I should see "You have signed up successfully"

  Scenario: Logging in
    Given a user with email address "darthvader@galacticempire.gov" and password "padme4eva"
    When I go to the new user session page
    And I fill in "Email" with "darthvader@galacticempire.gov"
    And I fill in "Password" with "padme4eva"
    And I press "Sign in"
    Then I should see "Signed in successfully"
