'use strict'

app = angular.module "App"

app.factory 'UserService', ($http, API_URL) ->

  {
    logIn: (username, password) ->
      $http.post "#{API_URL}/login",
        username: username
        password: password
    logOut: ->
      $http.get "#{API_URL}/logout"
  }