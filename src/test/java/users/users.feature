Feature: Pruebas de API de gestión de cuentas de usuario

  Background:
    * url baseUrl
    * def userData = defaultUserData()

  Scenario: Crear cuenta de usuario, actualizarla y verificar actualización
    # Crear usuario
    Given path 'createAccount'
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
    Then status 200
    And match response.responseCode == 201
    And match response.message == 'User created!'

    # Actualizar usuario (PUT)
    Given path 'updateAccount'
    And form field name = 'Updated Name'
    And form field email = userData.email
    And form field password = userData.password
    And form field title = 'Mrs'
    And form field birth_date = userData.birth_date
    And form field birth_month = userData.birth_month
    And form field birth_year = userData.birth_year
    And form field firstname = 'UpdatedFirst'
    And form field lastname = 'UpdatedLast'
    And form field company = userData.company
    And form field address1 = userData.address1
    And form field address2 = userData.address2
    And form field country = userData.country
    And form field zipcode = userData.zipcode
    And form field state = userData.state
    And form field city = userData.city
    And form field mobile_number = userData.mobile_number
    When method put
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'User updated!'

  Scenario: Crear cuenta de usuario y luego eliminarla
    # Crear usuario
    * def newUserData = defaultUserData()
    Given path 'createAccount'
    And form field name = newUserData.name
    And form field email = newUserData.email
    And form field password = newUserData.password
    And form field title = newUserData.title
    And form field birth_date = newUserData.birth_date
    And form field birth_month = newUserData.birth_month
    And form field birth_year = newUserData.birth_year
    And form field firstname = newUserData.firstname
    And form field lastname = newUserData.lastname
    And form field company = newUserData.company
    And form field address1 = newUserData.address1
    And form field address2 = newUserData.address2
    And form field country = newUserData.country
    And form field zipcode = newUserData.zipcode
    And form field state = newUserData.state
    And form field city = newUserData.city
    And form field mobile_number = newUserData.mobile_number
    When method post
    Then status 200
    And match response.responseCode == 201
    And match response.message == 'User created!'

    # Eliminar usuario
    Given path 'deleteAccount'
    And form field email = newUserData.email
    And form field password = newUserData.password
    When method delete
    Then status 200
    And match response.responseCode == 200
    And match response.message == 'Account deleted!'