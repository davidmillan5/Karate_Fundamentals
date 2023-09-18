Feature: Test on the Globomantics Products API

Background:
  * url 'http://localhost:8080/api/'

  Given path 'authenticate'
  And request '{"username":"admin","password":"admin"}'
  And header Content-Type = 'application/json'
  When method Post 
  Then status 200
  * def token = response.token
  * print 'Value of token: ' + token

Scenario: Get all Products
  Given path 'product'
  When method Get
  Then status 200


Scenario: Create and Delete Product
  * def productName = 'Fast train'
  * def productJSON = 
  """
    {
      "name": #(productName),
      "description": "A toy train with 3 carriages",
      "price": "19.99",
      "categoryId": 1,
      "inStock": true
    }
  """

  #Create a Product
  Given path 'product'
  And header Authorization = 'Bearer ' + token
  And header Content-Type = 'application/json'
  And request productJSON
  When method Post 
  Then status 200
  And match response.name == productName
  * def productId = response.id

  # Get single product
  Given path 'product', productId
  When method Get
  Then status 200
  And match response.id == productId 
  And match response.name == productName

  #Delete product
  Given path 'product', productId 
  And header Authorization = 'Bearer ' + token 
  And header Content-Type = 'application/json'
  When method delete
  Then status 200 
  And match response == 'Product: '+ productName + ' deleted successfully'

Scenario: Update Product
  * def updatedProductName = 'Updated fast train'

  * def updatedProductJSON =
  """
    {
      "name": #(updatedProductName),
      "description":  "A toy train with 3 carriages",
      "price": "29.99",
      "categoryId": 2,
      "inStock": true
    }
  """

  Given path 'product',10
  And header Authorization = 'Bearer ' + token
  And header Content-type = 'application/json'
  And request updatedProductJSON
  When method Put 
  Then status 200
  And match response.name == updatedProductName



Scenario: Query Parameters
  * def categoryId = '1'
  Given path 'product'
  And param category = '1'
  When method Get
  Then status 200
  And match each response contains {"categoryId": '1'}
  And match each response contains {"categoryId": #(categoryId)}


