'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService, AuthService) ->

  $scope.data = []
  $scope.orderByField = 'id';
  $scope.reverseSort = false;
  $scope.updatableUser = {}
  $scope.isLoggedIn = AuthService.isLogged
  $scope.username = AuthService.username

  resetForm = ->
    $scope.form = {}
    $scope.showForm = false

  getUsers = ->
    dataService.getUsers()
    .then (data) ->
      $scope.data = data.result

  $scope.formSubmit = (isValid, form) ->
    return unless isValid
    dataService.addUser(form)
    .then (result) ->
      form.id = result.result.insertId
      $scope.data.push form
      resetForm()

  $scope.setUpdateMode = (user) ->
    $scope.updatableUser = angular.copy user

  $scope.updateUser = (user) ->
    dataService.updateUser($scope.updatableUser)
    .then (result) ->
      angular.extend user, $scope.updatableUser
      $scope.cancelUpdating()

  $scope.cancelUpdating = (user) ->
    $scope.updatableUser = {}

  $scope.deleteUser = (userId) ->
    dataService.deleteUser(userId)
    .then (result) ->
      $scope.data = $scope.data.filter((item) -> item.id isnt userId)
      $scope.cancelUpdating()

  $scope.getTemplate = (id) ->
    templateEditMode = "scripts/pages/main/editable-content-template.html"
    templateDefaultMode = "scripts/pages/main/default-content-template.html"
    return if id is $scope.updatableUser.id then templateEditMode else templateDefaultMode

  getUsers()
  resetForm()