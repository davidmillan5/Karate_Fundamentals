
Feature: Test on the Globomantics Products API

Background:
  * url apiUrl
  * def productRequestBody = read('classpath:globomantics/data/newProduct.json')
  * callonce read('classpath:helpers/ProductSchema.feature')


Scenario: Get all Products
  Given path 'product'
  When method Get
  Then status 200

  And match response[0].name == 'Vintage Minature Car' 

  And match response[0].createdAt contains '2020'

  And match each response == productSchema


Scenario: Create and Delete Product
  * def productName = 'Fast train'
  * set productRequestBody.name = productName


  #Create a Product
  Given path 'product'
  And header Content-Type = 'application/json'
  And request productRequestBody
  When method Post 
  Then status 200
  And match response.name == productName
  And match response == productSchema
  * def productId = response.id

  # Get single product
  Given path 'product', productId
  When method Get
  Then status 200
  And match response.id == productId 
  And match response.name == productName
  And match response == productSchema

  #Delete product
  Given path 'product', productId 
  And header Content-Type = 'application/json'
  When method delete
  Then status 200 
  And match response == 'Product: '+ productName + ' deleted successfully'

Scenario: Update Product
  * def updatedProductName = 'Updated fast train'
  * set productRequestBody.name = updatedProductName



  Given path 'product',10
  And header Content-type = 'application/json'
  And request productRequestBody
  When method Put 
  Then status 200
  And match response.name == updatedProductName
  And match response == productSchema



Scenario: Query Parameters
  * def categoryId = '1'
  Given path 'product'
  And param category = '1'
  When method Get
  Then status 200
  And match each response contains {"categoryId": '1'}
  And match each response contains {"categoryId": #(categoryId)}
  And match each response..categoryId == categoryId
  And match each response == productSchema


