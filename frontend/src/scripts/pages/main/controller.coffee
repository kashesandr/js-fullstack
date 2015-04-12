'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService, AuthService) ->
  $scope.data = []
  $scope.orderByField = 'username';
  $scope.reverseSort = false;
  $scope.showForm = false
  $scope.isLoggedIn = AuthService.isLogged
  $scope.passwordChecked = null

  dataService.getUsers()
  .then (data) ->
    $scope.data = data.result

  $scope.formSubmit = (data) ->
    $scope.passwordChecked = data.password is data.passwordcheck
    return if !$scope.passwordChecked
