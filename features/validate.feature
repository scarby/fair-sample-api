Feature: JSON to email

   when i submit JSON to the API it should send an e-mail if its valid or fail if not

Scenario: valid JSON reults in a email
  When  I request to create an email with:
    | attribute | type   | value |  
    | from      | string | scarby@scarby.co.uk    |                     
    | to        | string | scarby2@gmail.com   |
    | subject   | string | This is only a test |
    | body      | string | body |
  Then the request is successful

Scenario: invalid JSON is rejected
  When  I request to create an email with:
    | attribute | type   | value |  
    | from      | string | 12    |                     
    | to        | string | foo   |
    | subject   | string | This is only a test |
    | body      | string | This really is only a test |
  Then the request failed because it was invalid 