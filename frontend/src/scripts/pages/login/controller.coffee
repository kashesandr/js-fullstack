'use strict'

app = angular.module 'App'

app.controller "loginController", ($scope, $window, $location, UserService, AuthService) ->

  $scope.logIn = (username, password) ->

    if angular.isDefined(username) and angular.isDefined(password)

      UserService.logIn(username, password)

      .success (data) ->
        AuthService.isLogged = true
        AuthService.username = username
        $window.sessionStorage.token = data.token
        $location.path '/'

      .error (status, data) ->
        console.log "Login error: #{status}"