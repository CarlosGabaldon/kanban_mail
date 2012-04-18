Feature: Item list
   
  In order to process items
  As a user
  I want a list of new, action, hold, and completed items.
  
  Scenario: Display list of new items
    Given I am logged into my account
    Given my account has new items
    When I access the item list page
    Then I should be displayed my new items.
    
  Scenario: Display list of action items
    Given I am logged into my account
    Given my account has action items
    When I access the item list page
    Then I should be displayed my action items.
    
  Scenario: Display list of hold items
    Given I am logged into my account
    Given my account has hold items
    When I access the item list page
    Then I should be displayed my hold items.
    
  Scenario: Display list of completed items 
    Given I am logged into my account
    Given my account has completed items
    When I access the item list page
    Then I should be displayed my completed items.
  
  
  
  
  
  
  
  
  
  
  
  

  
