Feature: Delete user reusable action

Scenario: Delete user account
  Given url baseUrl
  And path 'deleteAccount'
  And form field email = deleteData.email
  And form field password = deleteData.password
  When method delete
  * def result = response