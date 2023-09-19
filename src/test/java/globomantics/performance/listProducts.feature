@debug
Feature: List all products for Performance Test

Background: Define URL
  * url apiUrl

Scenario: Get all products
  Given path 'product'
  And header karate-request = 'Get All Products'
  When method Get 
  Then status 200


