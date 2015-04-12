'use strict'

app = angular.module "App"

app.factory 'UserService', ($http, GLOBAL_CONFIGS) ->
  API = GLOBAL_CONFIGS.api
  apiUrl = "#{API.protocol}#{API.host}:#{API.port}#{API.path}"
  console.log apiUrl
  {
    logIn: (username, password) ->
      $http.post "#{apiUrl}/login",
        username: username
        password: password
    logOut: ->
  }