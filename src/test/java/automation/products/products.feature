Feature: Pruebas de API de listado de productos

  Background:
    * url baseUrl

  Scenario: Obtener lista de todos los productos - debe devolver 200
    Given path 'productsList'
    When method get
    Then status 200
    And match response.products == '#array'
    And match response.products[0] contains { id: '#number', name: '#string', price: '#string' }