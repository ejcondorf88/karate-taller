Feature: Update user reusable action

Scenario: Update user account
  Given url baseUrl
  And path 'updateAccount'
  And form field name = updateData.name
  And form field email = updateData.email
  And form field password = updateData.password
  And form field title = updateData.title
  And form field birth_date = updateData.birth_date
  And form field birth_month = updateData.birth_month
  And form field birth_year = updateData.birth_year
  And form field firstname = updateData.firstname
  And form field lastname = updateData.lastname
  And form field company = updateData.company
  And form field address1 = updateData.address1
  And form field address2 = updateData.address2
  And form field country = updateData.country
  And form field zipcode = updateData.zipcode
  And form field state = updateData.state
  And form field city = updateData.city
  And form field mobile_number = updateData.mobile_number
  When method put
  * def result = response