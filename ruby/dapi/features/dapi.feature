Feature:

  Test the HTTP interfaces with Cucumber

  Scenario: View the root url of the app, and see the Cases

    When  the user visits path '/'
    Then  the page status code is '200'
    And   the page path is '/'
    And   the page has content: Cases
    And   the page has content: Blurb
    And   the page has content: Welcome to Desk.com
    And   the page has content: Thanks for trying Desk.com.

  Scenario: Navigate to the Cases page and view them

    When  the user visits path '/'
    And   the user clicks the link 'Cases'
    Then  the page status code is '200'
    And   the page path is '/cases/index'
    And   the page has content: Cases

  Scenario: Navigate to the Labels page and view them

    When  the user visits path '/'
    And   the user clicks the link 'Labels'
    Then  the page status code is '200'
    And   the page path is '/labels/index'
    And   the page has content: Name
    And   the page has content: Abandoned Chats
