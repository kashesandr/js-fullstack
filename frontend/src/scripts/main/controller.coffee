'use strict'

app = angular.module 'App'

app.controller "mainController", ($scope) ->
    $scope.data = {}
    $scope.$on "dataLoaded", (e, data) ->
        data.forEach (item) ->
            item
        $scope.data = data