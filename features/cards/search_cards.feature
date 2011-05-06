Feature: User indexes cards

  As a user
  I want to search and browse cards
  So that I can find out information about cards in the database
  
  Scenario: User searches cards index
    Given a logged in user
    And some cards
    When I go to the cards page
    And I search for "vader"    
    Then I should see matching cards

  Scenario: Persisting card result filters
    Given a logged in user
    And some cards
    And I am on the home page

    When I follow "Cards"
    And I fill in "search_box" with "Card"
    And I press "Search"
    Then I should see "Card" within "#search_details h2"

    When I follow "Light"
And show me the page
    Then I should see "Card" within "#search_details h2"
    And I should see "Light" within "#search_details h3"

    When I follow "Virtual Block 1"
    Then I should see "Card" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"

    When I follow "Remove" within "#search_details h3:first"
    Then I should not see "Virtual Block 1" within "#search_details"
    But I should see "Card" within "#search_details h2"
    But I should see "Light" within "#search_details"

    When I follow "Remove" within "#search_details h3:first"
    Then I should not see "Light" within "#search_details"
    But I should see "Card" within "#search_details h2"

    When I follow "Remove" within "#search_details h2"
    Then I should not see "Card" within "#search_details h2"

