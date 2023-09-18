Feature:

Scenario:
  * url apiUrl
  Given path 'authenticate'
  And request {"username":"#(adminUsername)","password":"#(adminPassword)"}
  And header Content-Type = 'application/json'
  When method Post 
  Then status 200
  * def token = response.token
  * print 'Value of token: ' + token
