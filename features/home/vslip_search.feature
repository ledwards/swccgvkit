Feature: User searches for virtual cards on the home page 

  As a user
  I want to search and browse vslips
  So that I can pick vslips to add to my cardlists
  
  Scenario: User searches cards index
    Given a logged in user
    And cards with the following attributes:
      | title          |
      | Luke Skywalker |
      | Darth Vader    |
    And a card with title "No vslip Vader" and no vslip image
    When I go to the home page
    And I search for "Vader"
    Then I should see "Darth Vader"
    And I should not see "Luke Skywalker"
    And I should not see "No vslip Vader"

  @javascript
  Scenario: Persisting card result filters and current cardlist
    Given a logged in user
    And cards with the following attributes:
      | title    | side  | expansion       |
      | Luke     | Light | Virtual Block 1 |
      | Vader    | Dark  | Virtual Block 1 |
      | Luke (V) | Light | Virtual Block 2 |

    And a cardlist named "My Cardlist"
    And I am on the home page

    When I fill in "search_box" with "Luke"
    And I press "Search"
    And I should see "Luke" within "#search_details h2"

    When I follow "My Cardlist"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Luke" within "#search_details h2"
    And I should see "My Cardlist" within ".cardlist_title"

    When I follow "Light"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Luke" within "#search_details h2"
    And I should see "Light" within "#search_details h3"
    And I should see "My Cardlist" within "#current_cardlist"

    When I follow "Virtual Block 1"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Luke" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"
    And I should see "My Cardlist" within "#current_cardlist"

    When I press "New"
    And I wait for the AJAX call to finish
    Then I should see "Luke" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"
    But I should not see "My Cardlist" within "#current_cardlist"

    When I follow "My Cardlist"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should see "Luke" within "#search_details h2"
    And I should see "Light" within "#search_details"
    And I should see "Virtual Block 1" within "#search_details"
    And I should see "My Cardlist" within "#current_cardlist"

    When I follow "Remove" within "#search_details h3:first"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should not see "Virtual Block 1" within "#search_details"
    But I should see "Luke" within "#search_details h2"
    But I should see "Light" within "#search_details"
    But I should see "My Cardlist" within "#current_cardlist"

    When I follow "Remove" within "#search_details h3:first"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should not see "Light" within "#search_details"
    But I should see "Luke" within "#search_details h2"
    But I should see "My Cardlist" within "#current_cardlist"

    When I follow "Remove" within "#search_details h2"
    And I add a card to the current cardlist
    And I wait for the AJAX call to finish
    Then I should not see "Luke" within "#search_details h2"
    But I should see "My Cardlist" within "#current_cardlist"

