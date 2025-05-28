Feature: API Testing

  @AUT-73
  Scenario: Fetching a list of posts
    Given I send a GET request to "/posts"
    Then the response status code should be 200
    And the response should contain a list of posts
    And the response should contain this post details
      | userId | 8  |
      | id     | 73 |
      | title  | consequuntur deleniti eos quia temporibus ab aliquid at |
      | body   | voluptatem cumque tenetur consequatur expedita ipsum nemo quia explicabo\naut eum minima consequatur\ntempore cumque quae est et\net in consequuntur voluptatem voluptates aut |