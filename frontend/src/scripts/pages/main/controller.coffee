'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService, AuthService) ->
  $scope.data = []
  $scope.orderByField = 'id';
  $scope.reverseSort = false;
  $scope.editMode = false
  $scope.showForm = false
  $scope.isLoggedIn = AuthService.isLogged
  $scope.username = AuthService.username
  $scope.passwordChecked = null
  $scope.currentSelectedId = null

  $scope.setSelectedRow = (id) ->
    return unless $scope.isLoggedIn
    $scope.currentSelectedId = id

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

  $scope.editUser = (user) ->
    dataService.editUser(user)
    .then (result) ->
      getUsers()

  $scope.deleteUser = (userId) ->
    dataService.deleteUser(userId)
    .then (result) ->
      getUsers()