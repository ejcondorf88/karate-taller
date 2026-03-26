Feature: Invalid search products reusable action

Scenario: Search products without parameter
  Given url baseUrl
  And path 'searchProduct'
  When method post
  * def result = response