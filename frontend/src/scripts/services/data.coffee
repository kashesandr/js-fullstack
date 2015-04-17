'use strict'

app = angular.module 'App'

app.factory "dataService", ($rootScope, $resource) ->

    User = $resource "/api/users/:id", {}, {
        'get': {method: 'GET'}
        'save': {method: 'POST'}
        'update': {method: 'PUT'}
        'delete': {method: 'DELETE'}
    }

    getUsers = () ->
        User.get().$promise

    addUser = (data) ->
        User.save(data).$promise

    editUser = (data) ->
        User.update(data).$promise

    deleteUser = (userId) ->
        User.delete(id: userId).$promise

    {
        getUsers
        addUser
        editUser
        deleteUser
    }
