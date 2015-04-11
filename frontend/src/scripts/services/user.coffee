'use strict'

app = angular.module "App"

app.factory 'UserService', ($http) ->
  {
    logIn: (username, password) ->
      $http.post '/login',
        username: username
        password: password
    logOut: ->
  }