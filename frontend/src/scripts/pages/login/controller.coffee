'use strict'

app = angular.module 'App'

app.controller "loginController", ($scope, $window, $location, UserService, AuthService) ->
  $scope.logIn = (username, password) ->
    if angular.isDefined(username) and angular.isDefined(password)
      UserService.logIn(username, password).success( (data) ->
        AuthService.isLogged = true
        $window.sessionStorage.token = data.token
        $location.path '/main'
        return
      ).error (status, data) ->
        console.log status
        console.log data
        return
    return

  $scope.logout = ->
    if AuthService.isLogged
      AuthService.isLogged = false
      delete $window.sessionStorage.token
      $location.path '/'
    return