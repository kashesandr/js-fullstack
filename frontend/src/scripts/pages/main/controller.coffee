'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService) ->
  $scope.data = []
  $scope.orderByField = 'username';
  $scope.reverseSort = false;
  $scope.showForm = false

  dataService.getUsers()
  .then (data) ->
    $scope.data = data.result

  $scope.formSubmit = (data) ->
    if data.password isnt data.passwordcheck
      console.log 'error'
    console.log data