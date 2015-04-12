'use strict'

app = angular.module 'App'

app.controller "logoutController", ($scope, $location, $window, AuthService, UserService) ->
  console.log AuthService.isLogged
  if AuthService.isLogged
    UserService.logOut().success((data) ->
      AuthService.isLogged = false
      delete $window.sessionStorage.token
      $location.path '/login'
      return
    ).error (status, data) ->
      console.log "Log out error #{status}"
      console.log data
  else
    $location.path '/login'
