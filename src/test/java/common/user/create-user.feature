Feature: Create user reusable action

Scenario: Create user account
  Given url baseUrl
  And path 'createAccount'
  And form field name = userData.name
  And form field email = userData.email
  And form field password = userData.password
  And form field title = userData.title
  And form field birth_date = userData.birth_date
  And form field birth_month = userData.birth_month
  And form field birth_year = userData.birth_year
  And form field firstname = userData.firstname
  And form field lastname = userData.lastname
  And form field company = userData.company
  And form field address1 = userData.address1
  And form field address2 = userData.address2
  And form field country = userData.country
  And form field zipcode = userData.zipcode
  And form field state = userData.state
  And form field city = userData.city
  And form field mobile_number = userData.mobile_number
  When method post
  * def result = response