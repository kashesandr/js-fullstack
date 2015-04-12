'use strict'

app = angular.module 'App'

app.factory "dataService", ($rootScope, $resource) ->

    Users = $resource "/api/users", {}, {}

    getUsers = () ->
        Users.get().$promise

    {
        getUsers
    }
