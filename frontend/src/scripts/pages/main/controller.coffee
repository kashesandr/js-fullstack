'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope, dataService) ->
  $scope.data = []
  dataService.getUsers()
  .then (data) ->
    console.log data
    $scope.data = data.result
