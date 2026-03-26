Feature: Search products reusable action

Scenario: Search products with parameter
  Given url baseUrl
  And path 'searchProduct'
  And form field search_product = searchTerm
  When method post
  * def result = response