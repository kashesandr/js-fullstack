'use strict'

app = angular.module 'App'

app.factory "dataService", ($rootScope, $resource) ->

    User = $resource "/api/users/:id", {}, {
        'get': {method: 'GET'}
        'save': {method: 'POST'}
        'update': {method: 'PUT'}
        'delete': {method: 'DELETE'}
    }

    CheckUser = $resource "/api/checkuser/:username", {}, {
        'get': {method: 'GET'}
    }

    getUsers = () ->
        User.get().$promise

    addUser = (data) ->
        User.save(data).$promise

    editUser = (data) ->
        User.update(data).$promise

    deleteUser = (userId) ->
        User.delete(id: userId).$promise

    userExists = (username) ->
      CheckUser.get({username: username}).$promise

    {
        getUsers
        addUser
        editUser
        deleteUser
        userExists
    }
