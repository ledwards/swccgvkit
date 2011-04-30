Feature: User creates cardlists

  As a user
  I want to create a cardlist
  So that I can print multiple cards at once
  
  @javascript
  Scenario: Creating the first new cardlist
    Given a logged in user
    And some cards
    And I am on the home page
    When I fill in "search_box" with "Card"
    And I add a card to the current cardlist
    Then I should see "Card" within "#current_cardlist"
    
  @javascript
  Scenario: Creating a second cardlist
    Given a logged in user
    And some cards
    And a cardlist named "Old Cardlist"
    And I am on the home page

    When I follow "Old Cardlist"
    And I press "New"
    Then I should see "New Cardlist" within "#current_cardlist"
    
    And I add a card to the current cardlist
    Then I should see "Card" within "ul#cardlist"

  @javascript
  Scenario: Persisting card result filters and current cardlist
    Given a logged in user
    And some cards
    And a cardlist named "My Cardlist"
    And I am on the home page

    When I fill in "search_box" with "Card"
    And I press "Search"
    And I should see "Card" within "#search_details h2"

    When I follow "My Cardlist"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Card" within "#search_details h2"
    And I should see "My Cardlist" within ".cardlist_title"

    When I follow "Light"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Card" within "#search_details h2"
    And I should see "Light" within "#search_details h3"
    And I should see "My Cardlist" within "#current_cardlist"

    When I follow "Virtual Block 1"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Card" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"
    And I should see "My Cardlist" within "#current_cardlist"

    When I press "New"
    And I wait for the AJAX call to finish
    Then I should see "Card" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"
    But I should not see "My Cardlist" within "#current_cardlist"

    When I follow "My Cardlist"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Card" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"
    And I should see "My Cardlist" within "#current_cardlist"

    When I follow "Remove" within "#search_details h3:first"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should not see "Virtual Block 1" within "#search_details"
    But I should see "Card" within "#search_details h2"
    But I should see "Light" within "#search_details"
    But I should see "My Cardlist" within "#current_cardlist"

    When I follow "Remove" within "#search_details h3:first"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should not see "Light" within "#search_details"
    But I should see "Card" within "#search_details h2"
    But I should see "My Cardlist" within "#current_cardlist"

    When I follow "Remove" within "#search_details h2"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should not see "Card" within "#search_details h2"
    But I should see "My Cardlist" within "#current_cardlist"

