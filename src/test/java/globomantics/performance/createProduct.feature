@debug
Feature: Create and Delete Products for Performance Test

Background: Define URL and Request Body
  * url apiUrl
  * def productRequestBody = read('classpath:globomantics/data/newProduct.json')
  * set productRequestBody.name = __gatling.productName
  * set productRequestBody.description = __gatling.productDescription
  * set productRequestBody.price = __gatling.productPrice
  * set productRequestBody.catedoryId = __gatling.productCategory

Scenario: Create and delete products
  Given path 'product'
  And header Content-Type = 'application/json'
  And header karate-request = 'Create Product: ' + __gatling.productName
  And request productRequestBody
  When method Post 
  Then status 200
  * def productId = response.id 

  * karate.pause(10000)

  Given path 'product', productId 
  And header karate-request = "Delete Product"
  When method delete
  Then status 200 


