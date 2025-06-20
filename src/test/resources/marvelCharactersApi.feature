@REQ_BTM-2303 @HU2303 @marvel_characters_api @bp_se_test @Agente2 @E2 @iniciativa_marvel
Feature: BTM-2303 Marvel Characters API (microservicio para gestionar personajes de Marvel)

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/mastudma09'
    * path '/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-BTM-2303-CA01-Obtener todos los personajes 200 - karate
    When method GET
    Then status 200
    # And match response != null
    # And match response == '#array'

  @id:2 @obtenerPersonajes @listaVacia200
  Scenario: T-API-BTM-2303-CA02-Obtener lista vacía de personajes 200 - karate
    When method GET
    Then status 200
    # And match response == []
    # And match response.length == 0

  @id:3 @obtenerPersonajes @errorInterno500
  Scenario: T-API-BTM-2303-CA03-Obtener personajes con error interno 500 - karate
    * path '/api/characters3'
    When method GET
    Then status 500
    # And match response.error == 'Internal server error'
    # And match response contains { error: '#notnull' }

  @id:4 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-BTM-2303-CA04-Obtener personaje por ID exitoso 200 - karate
    * path '/api/characters/1'
    When method GET
    Then status 200
    # And match response != null
    # And match response.name == 'Iron Man'

  @id:5 @obtenerPersonajePorId @personajeNoEncontrado404
  Scenario: T-API-BTM-2303-CA05-Obtener personaje por ID no encontrado 404 - karate
    * path '/api/characters/999'
    When method GET
    Then status 404
    # And match response.error == 'Character not found'
    # And match response contains { error: '#notnull' }

  @id:6 @obtenerPersonajePorId @errorInterno500
  Scenario: T-API-BTM-2303-CA06-Obtener personaje por ID formato inválido 500 - karate
    * path '/api/characters/rf1'
    When method GET
    Then status 500
    # And match response.error == 'Internal server error'
    # And match response contains { error: '#notnull' }

  @id:7 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-BTM-2303-CA07-Crear personaje exitoso 201 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    And request jsonData
    When method POST
    Then status 201
    # And match response.id == '#notnull'
    # And match response.name == jsonData.name

  @id:8 @crearPersonaje @datosInvalidos400
  Scenario: T-API-BTM-2303-CA08-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.name == 'Name is required'
    # And match response.alterego == 'Alterego is required'

  @id:9 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-BTM-2303-CA09-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.error == 'Character name already exists'
    # And match response contains { error: '#notnull' }

  @id:10 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-BTM-2303-CA10-Actualizar personaje exitoso 200 - karate
    * path '/api/characters/1'
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 200
    # And match response.id == 1
    # And match response.name == jsonData.name

  @id:11 @actualizarPersonaje @personajeNoEncontrado404
  Scenario: T-API-BTM-2303-CA11-Actualizar personaje no encontrado 404 - karate
    * path '/api/characters/999'
    * def jsonData = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 404
    # And match response.error == 'Character not found'
    # And match response contains { error: '#notnull' }

  @id:12 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-BTM-2303-CA12-Eliminar personaje exitoso 204 - karate
    * path '/api/characters/1'
    When method DELETE
    Then status 204
    # Y no hay response body que validar para 204
    # And match response == ''

  @id:13 @eliminarPersonaje @personajeNoEncontrado404
  Scenario: T-API-BTM-2303-CA13-Eliminar personaje no encontrado 404 - karate
    * path '/api/characters/999'
    When method DELETE
    Then status 404
    # And match response.error == 'Character not found'
    # And match response contains { error: '#notnull' }
