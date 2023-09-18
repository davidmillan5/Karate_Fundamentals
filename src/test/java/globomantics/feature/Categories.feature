Feature: Test on the globomantics Categories API

Background:
  * url 'http://localhost:8080/api/'

  Given path 'authenticate'
  And request '{"username":"admin","password":"admin"}'
  And header Content-Type = 'application/json'
  When method Post 
  Then status 200
  * def token = response.token
  * print 'Value of token: ' + token

Scenario: Get all categories
  Given path 'category'
  When method Get
  Then status 200

Scenario: Create a Category
  Given path 'category'
  And header Authorization = 'Bearer ' + token
  And header Content-Type = 'application/json'
  And request '{"name":"My new category"}'
  When method Post 
  Then status 200

Scenario: Create, Update and Delete Category

  * def categoryName = 'Brand New Toys'
  * def categoryNameUpdated = 'Updated brand new toys'

  #Create Category
  Given path 'category'
  And header Authorization = 'Bearer ' + token
  And header Content-Type = 'application/json'
  And request '{"name": "' + categoryName + '"}'
  When method Post 
  Then status 200
  And match response.name == categoryName
  * def categoryId = response.id 

  Given path 'category', categoryId
  When method Get 
  Then status 200 
  And match response.id == categoryId 
  And match response.name == categoryName

  # Update category
  Given path 'category', categoryId 
  And header Authorization = 'Bearer ' + token
  And header Content-Type = 'application/json'
  And request '{"name": "' + categoryNameUpdated + '"}'
  When method Put 
  Then status 200
  And match response.name == categoryNameUpdated

  Given path 'category', categoryId
  When method Get 
  Then status 200 
  And match response.id == categoryId 
  And match response.name == categoryNameUpdated

  # Delete Category

  Given path 'category', categoryId 
  And header Authorization = 'Bearer ' + token
  And header Content-Type = 'application/json'
  When method Delete
  Then status 200
  And match response == "Category: " + categoryNameUpdated + " deleted successfully"



