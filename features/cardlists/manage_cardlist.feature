Feature: User creates cardlists

  As a user
  I want to edit a cardlist
  So that I can evolve my cardlists over time

  @javascript
  Scenario: Remove a card from the cardlist
    Given a logged in user
    And cards with the following attributes:
      | title             |
      | Darth Vader       |
      | Grand Moff Tarkin |
    And I am on the home page

    When I press "New"
    And I add "Darth Vader" to the current cardlist
    And I add "Grand Moff Tarkin" to the current cardlist
    Then I not see "Darth Vader" within the current cardlist
    Then I not see "Grand Moff Tarkin" within the current cardlist
    Then I should have 2 cards in my cardlist

    When I remove "Darth Vader" from the current cardlist
    Then I should not see "Darth Vader" within the current cardlist
    And I should have 1 card in my cardlist
