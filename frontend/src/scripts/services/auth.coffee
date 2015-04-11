'use strict'

app = angular.module 'App'

app.factory 'AuthService', ->
  {
    isLogged: false
  }
