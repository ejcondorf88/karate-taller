@products
Feature: Pruebas de API de productos (listado y búsqueda)

  Background:
    * url baseUrl

  @get @smoke @listProducts
  Scenario: Obtener lista de todos los productos - debe devolver 200
    Given path 'productsList'
    When method get
    Then status 200
    And match response.products == '#array'
    And match response.products[0] contains { id: '#number', name: '#string', price: '#string' }

  @post @smoke @searchProduct
  Scenario: Buscar producto con parámetro válido - debe devolver 200
    Given path 'searchProduct'
    And form field search_product = 'top'
    When method post
    Then status 200
    And match response.products == '#array'
    And match each response.products contains { name: '#string' }

  @post @searchProduct @error
  Scenario: Buscar producto sin parámetro - debe devolver 400 en el cuerpo de respuesta
    Given path 'searchProduct'
    When method post
    Then status 200
    And match response.responseCode == 400
    And match response.message == 'Bad request, search_product parameter is missing in POST request.'