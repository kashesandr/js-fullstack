'use strict'

app = angular 'App'

app.factory 'AuthService', ->
  {
    isLogged: false
  }
