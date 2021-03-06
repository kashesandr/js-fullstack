'use strict'

app = angular.module 'App'

app.controller "logoutController", ($scope, $location, $window, AuthService, UserService) ->

  if AuthService.isLogged
    UserService.logOut()
    .success (data) ->
      AuthService.isLogged = false
      AuthService.username = ''
      delete $window.sessionStorage.token
      $location.path '/'
    .error (status, data) ->
      console.log "Log out error #{status}"
  else
    $location.path '/'
