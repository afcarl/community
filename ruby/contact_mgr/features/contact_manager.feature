Feature:

  Testing the UI of the Contact Manager application
  Since this is a small application, we'll test it in just this one feature file.

  Background:
    Given the standard fixture data is loaded

  Scenario:
    The root or home page of the app should list the standard set of users,
    and have the New Contact button, and author footer.

    Given the user visits the application root path
    Then  the page path is '/'
    And   the '+ New Contact' button is present
    And   the '- Delete Contact' button is absent
    And   the following text, in this sequence, is expected in the page body:
          | Contact Manager               |
          | Doug Stamper                  |
          | Francis Underwood             |
          | Zoey Barnes                   |
          | ©christopher.joakim@gmail.com |

  Scenario:
    Show, then Edit, a Contact.

    Given the user visits the application root path
    And   the user clicks the link 'Doug Stamper'
    Then  the page is logged
    And   the page path matches pattern '/contacts/{n}'
    And   the following text, in this sequence, is expected in the page body:
          | Contact Manager        |
          | Doug Stamper           |
          | male                   |
          | 50                     |
          | 1964-01-04             |
          | 77 Main St             |
          | Washington DC, 20004   |
          | 555-555-5555           |
          | thestamper@hotmail.com |

    When  the user clicks the Edit link
    Then  the page path matches pattern '/contacts/{n}/edit'
    And   the page has the text 'thestamper@hotmail.com'
    And   the 'Save' button is present

    When  the user fills in field 'contact_name' with 'Doug Stamperr'
    When  the user clicks the 'Save' button
    Then  the page path matches pattern '/contacts/{n}'
    And   the following text, in this sequence, is expected in the page body:
          | Contact Manager                   |
          | Contact was successfully updated. |
          | Doug Stamperr                     |


  Scenario:
    Create a Contact.

    Given the user visits the application root path
    When  the user clicks the link '+ New Contact'
    Then  the page path is '/contacts/new'

    When  the user clicks the 'Save' button
    Then  the page path is '/contacts'
    And   the following text, in this sequence, is expected in the page body:
          | 5 errors prohibited this contact from being saved: |
          | Name is too short (minimum is 4 characters)        |
          | Street is too short (minimum is 4 characters)      |
          | City is too short (minimum is 2 characters)        |
          | State is too short (minimum is 2 characters)       |
          | Postal code is too short (minimum is 5 characters) |

    When  the user fills in field 'contact_name' with 'David B'
    And   the user fills in field 'contact_street' with 'South Street'
    And   the user fills in field 'contact_city' with 'Davidson'
    And   the user fills in field 'contact_state' with 'NC'
    And   the user fills in field 'contact_postal_code' with '28036'
    And   the user fills in field 'contact_phone' with '704-896-1234'
    And   the user fills in field 'contact_email' with 'daveb@dav.net'

    When  the user clicks the 'Save' button
    Then  the page path matches pattern '/contacts/{n}'
    And   the following text, in this sequence, is expected in the page body:
          | Contact Manager                  |
          | Contact was successfully created |
          | David B                          |
          | male                             |
          | South Street                     |
          | Davidson NC, 28036               |
          | 704-896-1234                     |
          | daveb@dav.net                    |

    Given the user visits the application root path
    And   the following text, in this sequence, is expected in the page body:
          | Contact Manager               |
          | Doug Stamper                  |
          | Francis Underwood             |
          | Zoey Barnes                   |
          | David B                       |
          | ©christopher.joakim@gmail.com |
