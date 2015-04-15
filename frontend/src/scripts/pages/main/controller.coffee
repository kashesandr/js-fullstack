'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService, AuthService) ->
  $scope.data = []
  $scope.orderByField = 'username';
  $scope.reverseSort = false;

  $scope.showForm = false
  $scope.isLoggedIn = AuthService.isLogged
  $scope.username = AuthService.username
  $scope.passwordChecked = null

  dataService.getUsers()
  .then (data) ->
    $scope.data = data.result

  $scope.formSubmit = (form) ->
    $scope.passwordChecked = form.password is form.passwordcheck
    return if !$scope.passwordChecked
    dataService.addUser(form)
    .then (result) ->
      console.log result
