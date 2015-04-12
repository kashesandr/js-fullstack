'use strict'

app = angular.module "App"

app.factory 'UserService', ($http, GLOBAL_CONFIGS) ->
  API = GLOBAL_CONFIGS.api
  apiUrl = "#{API.protocol}#{API.host}:#{API.port}#{API.path}"
  {
    logIn: (username, password) ->
      $http.post "#{apiUrl}/login",
        username: username
        password: password
    logOut: ->
      $http.get "#{apiUrl}/logout"
  }