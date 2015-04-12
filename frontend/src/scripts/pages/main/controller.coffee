'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService) ->
  $scope.data = []
  $scope.orderByField = 'username';
  $scope.reverseSort = false;

  dataService.getUsers()
  .then (data) ->
    console.log data
    $scope.data = data.result
