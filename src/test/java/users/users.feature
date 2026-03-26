@users
Feature: User API test flows

Background:
  * url baseUrl
  * def userDataTemplate = read('classpath:data/user-data.json')


@smoke @regression @post @createUser
Scenario: Create user account
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = generateEmail()
  * def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  Then match createRes.result.responseCode == 201
  And match createRes.result.message == 'User created!'


@regression @put @updateUser
Scenario: Update user account
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = generateEmail()
  
  # First create user
  * def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  * match createRes.result.responseCode == 201
  
  # Then update
  * def updateData = deepCopy(userData)
  * set updateData.name = 'Updated Name'
  * set updateData.title = 'Mrs'
  
  * def updateRes = call read('classpath:common/user/update-user.feature') { updateData: '#(updateData)' }
  
  Then match updateRes.result.responseCode == 200
  And match updateRes.result.message == 'User updated!'

@regression @delete @deleteUser
Scenario: Delete user account
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = generateEmail()
  
  # First create user
  * def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  * match createRes.result.responseCode == 201
  
  # Then delete
  * def deleteData = { email: '#(userData.email)', password: '#(userData.password)' }
  * print 'deleteData:', deleteData
  * def deleteRes = call read('classpath:common/user/delete-user.feature') { deleteData: '#(deleteData)' }
  
  Then match deleteRes.result.responseCode == 200
  And match deleteRes.result.message == 'Account deleted!'


@edge-case @createUser
Scenario: Create user with existing email - should return 400
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = 'test@example.com'
  
  # First create user
  * def createRes1 = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  
  # Try to create again with same email
  * def createRes2 = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  
  Then match createRes2.result.responseCode == 400
  And match createRes2.result.message == 'Email already exists!'


@edge-case @createUser
Scenario: Create user with missing required fields - API accepts empty name
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = generateEmail()
  * set userData.name = ''
  
  * def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  
  Then match createRes.result.responseCode == 201
  And match createRes.result.message == 'User created!'


@edge-case @updateUser
Scenario: Update user without email parameter - API returns 404 (account not found)
  * def userData = deepCopy(userDataTemplate)
  * set userData.email = generateEmail()
  
  # First create user
  * def createRes = call read('classpath:common/user/create-user.feature') { userData: '#(userData)' }
  * match createRes.result.responseCode == 201
  
  # Try update without email (required field) - returns 404
  * def updateData = { name: 'Updated Name', email: '', password: 'password123' }
  * def updateRes = call read('classpath:common/user/update-user.feature') { updateData: '#(updateData)' }
  
  Then match updateRes.result.responseCode == 404
  And match updateRes.result.message == 'Account not found!'


@edge-case @deleteUser
Scenario: Delete user with wrong credentials - should return 404
  * def deleteData = { email: 'nonexistent@test.com', password: 'wrongpassword' }
  * def deleteRes = call read('classpath:common/user/delete-user.feature') { deleteData: '#(deleteData)' }
  
  Then match deleteRes.result.responseCode == 404
  And match deleteRes.result.message == 'Account not found!'