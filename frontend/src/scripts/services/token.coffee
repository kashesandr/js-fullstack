'use strict'

app = angular.module "App"

app.factory 'TokenInterceptor', ($q, $window, $location, AuthService) ->

  {
    request: (config) ->
      config.headers = config.headers or {}
      if $window.sessionStorage.token
        config.headers.Authorization = 'Bearer ' + $window.sessionStorage.token
      config

    requestError: (rejection) ->
      $q.reject rejection

    response: (response) ->
      if response isnt null and response.status is 200 and $window.sessionStorage.token and !AuthService.isLogged
        AuthService.isLogged = true
      response or $q.when(response)

    responseError: (rejection) ->
      if rejection != null and rejection.status == 401 and ($window.sessionStorage.token or AuthService.isLogged)
        delete $window.sessionStorage.token
        AuthService.isLogged = false
        $location.path "/login"
      $q.reject rejection
  }