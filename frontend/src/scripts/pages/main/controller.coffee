'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService, AuthService) ->
  $scope.data = []
  $scope.orderByField = 'id';
  $scope.reverseSort = false;
  $scope.updatableUser = {}
  $scope.showForm = false
  $scope.isLoggedIn = AuthService.isLogged
  $scope.username = AuthService.username
  $scope.passwordConfirmed = null
  $scope.isUserExists = null

  getUsers = ->
    dataService.getUsers()
    .then (data) ->
      $scope.data = data.result

  $scope.checkPassword = (password1, password2) ->
    return unless angular.isDefined(password1) and angular.isDefined(password2)
    $scope.passwordConfirmed = password1 is password2
    $scope.passwordConfirmed

  $scope.formSubmit = (form) ->
    dataService.addUser(form)
    .then (result) ->
      #insertId = result.insertId
      getUsers()
      $scope.showForm = false

  $scope.setUpdateMode = (user) ->
    user.updateMode = true
    $scope.updatableUser = angular.copy user

  $scope.updateUser = (user) ->
    dataService.updateUser($scope.updatableUser)
    .then (result) ->
      getUsers()

  $scope.cancelUpdate = (user) ->
    user.updateMode = false
    $scope.updatableUser = {}

  $scope.deleteUser = (userId) ->
    dataService.deleteUser(userId)
    .then (result) ->
      getUsers()

  $scope.userExists = (username) ->
    return false if username is ''
    dataService.userExists(username)
    .then (result) ->
      $scope.isUserExists = result.result

  $scope.getTemplate = (editMode) ->
    templateEditMode = "scripts/pages/main/editable-content-template.html"
    templateDefaultMode = "scripts/pages/main/default-content-template.html"
    return if editMode is true then templateEditMode else templateDefaultMode

  getUsers()