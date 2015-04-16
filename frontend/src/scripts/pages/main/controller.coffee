'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService, AuthService) ->
  $scope.data = []
  $scope.orderByField = 'id';
  $scope.reverseSort = false;

  $scope.showForm = false
  $scope.isLoggedIn = AuthService.isLogged
  $scope.username = AuthService.username
  $scope.passwordChecked = null
  $scope.currentSelectedRow = null

  $scope.setSelectedRow = (id) ->
    $scope.currentSelectedRow = id

  getUsers = ->
    dataService.getUsers()
    .then (data) ->
      $scope.data = data.result
  getUsers()

  $scope.formSubmit = (form) ->
    $scope.passwordChecked = form.password is form.passwordcheck
    return if !$scope.passwordChecked
    dataService.addUser(form)
    .then (result) ->
      #insertId = result.insertId
      getUsers()
