'use strict'

app = angular.module 'App', ['ui.bootstrap', 'GlobalConfigs', 'ngRoute', 'ngResource']

.run ($rootScope, $location, AuthService) ->

  $rootScope.$on '$routeChangeStart', (event, nextRoute, currentRoute) ->
    if nextRoute?.access?.requiredLogin and !AuthService.isLogged
      $location.path '/login'
