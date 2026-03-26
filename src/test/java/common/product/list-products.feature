Feature: List all products reusable action

Scenario: Get all products
  Given url baseUrl
  And path 'productsList'
  When method get
  * def result = response