@products
Feature: Pruebas de API de productos (listado y búsqueda)

  Background:
    * url baseUrl
    * def productData = loadProductData()

  @get @smoke @listProducts
  Scenario: Obtener lista de todos los productos - debe devolver 200
    * def listRes = call read('classpath:common/product/list-products.feature')
    Then match listRes.result.responseCode == 200
    And match listRes.result.products == '#array'
    And match listRes.result.products[0] contains { id: '#number', name: '#string', price: '#string' }

  @post @smoke @searchProduct
  Scenario: Buscar producto con parámetro válido - debe devolver 200
    * def searchTerm = productData.searchTerm
    * def searchRes = call read('classpath:common/product/search-product.feature') { searchTerm: '#(searchTerm)' }
    Then match searchRes.result.responseCode == 200
    And match searchRes.result.products == '#array'
    And match each searchRes.result.products contains { name: '#string' }

@post @searchProduct @error
Scenario: Buscar producto sin parámetro - debe devolver 400 en el cuerpo de respuesta
  * def searchRes = call read('classpath:common/product/invalid-search.feature')
  Then match searchRes.result.responseCode == 400
  And match searchRes.result.message == 'Bad request, search_product parameter is missing in POST request.'

@edge-case @searchProduct
Scenario: Buscar producto con término vacío - debe devolver todos los productos
  * def searchTerm = ''
  * def searchRes = call read('classpath:common/product/search-product.feature') { searchTerm: '#(searchTerm)' }
  Then match searchRes.result.responseCode == 200
  And match searchRes.result.products == '#array'
  And match searchRes.result.products[0].id == 1

@edge-case @searchProduct
Scenario: Buscar producto con caracteres especiales - debe devolver 200 o 400
  * def searchTerm = '!@#$%^&*()'
  * def searchRes = call read('classpath:common/product/search-product.feature') { searchTerm: '#(searchTerm)' }
  Then match searchRes.result.responseCode == 200
  And match searchRes.result.products == '#array'

@edge-case @searchProduct
Scenario: Buscar producto con término sin resultados - debe devolver 200 con array vacío
  * def searchTerm = 'xyznonexistent123'
  * def searchRes = call read('classpath:common/product/search-product.feature') { searchTerm: '#(searchTerm)' }
  Then match searchRes.result.responseCode == 200
  And match searchRes.result.products == '#array'