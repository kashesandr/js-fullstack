'use strict'

app = angular

.module 'App', ['angularMoment', 'ui.bootstrap', 'GlobalConfigs', 'ngRoute']

.config ($httpProvider, $routeProvider) ->
  $httpProvider.interceptors.push 'TokenInterceptor'
  $routeProvider
    .when '/main',
      templateUrl: 'scripts/pages/main/template.html'
      controller: 'mainController'
      access: requiredLogin: true
    .when '/login',
      templateUrl: 'scripts/pages/login/template.html'
      controller: 'loginController'
      access: requiredLogin: false
    .when '/404',
      templateUrl: 'scripts/pages/404/template.html'
      controller: '404Controller'
      access: requiredLogin: false
    .otherwise redirectTo: '/login'

.run ($rootScope, $location, AuthService) ->
  $rootScope.$on '$routeChangeStart', (event, nextRoute, currentRoute) ->
    if nextRoute.access?.requiredLogin? and !AuthService.isLogged
      $location.path '/login'
