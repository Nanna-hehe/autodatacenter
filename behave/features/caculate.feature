
Feature: Basic Arithmetic Operations

  @TWIN-29
  Scenario: Adding two numbers
    Given I have the number 1
    When I increase it by 2
    Then the result should return 3

  @TWIN-30
  Scenario: Subtracting two numbers
    Given I have the number 5
    When I subtract 3 from it
    Then the result should return 2