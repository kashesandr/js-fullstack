'use strict'

app = angular.module 'App'

app.factory "dataService", ($rootScope, $resource) ->

    User = $resource "/api/users", {}, {
        'get': {method: 'GET'}
        'save': {method: 'POST'}
    }

    getUsers = () ->
        User.get().$promise

    addUser = (data) ->
        User.save(data).$promise

    {
        getUsers
        addUser
    }
