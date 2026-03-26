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