Feature: Test on the globomantics Categories API

Background:
  * url apiUrl

Scenario: Get all categories
  Given path 'category'
  When method Get
  Then status 200

Scenario: Create a Category
  Given path 'category'
  And header Content-Type = 'application/json'
  And request '{"name":"My 3rd category"}'
  When method Post 
  Then status 200

Scenario: Create, Update and Delete Category

  * def categoryName = 'Brand New Toys'
  * def categoryNameUpdated = 'Updated brand new toys'

  #Create Category
  Given path 'category'
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
  And header Content-Type = 'application/json'
  When method Delete
  Then status 200
  And match response == "Category: " + categoryNameUpdated + " deleted successfully"



