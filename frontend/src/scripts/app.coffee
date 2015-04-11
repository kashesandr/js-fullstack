'use strict'

app = angular

.module 'App', ['angularMoment', 'ui.bootstrap', 'GlobalConfigs', 'ngRoute']

.config ($httpProvider, $routeProvider) ->
  $httpProvider.interceptors.push 'TokenInterceptor'
  $routeProvider
    .when '/main',
      templateUrl: 'scripts/main/template.html'
      controller: 'mainController'
      access: requiredLogin: false
    .when '/login',
      templateUrl: 'scripts/pages/login/template.html'
      controller: 'loginController'
      access: requiredLogin: false
    .when '/logout',
      templateUrl: 'scripts/pages/logout/template.html'
      controller: 'logoutController'
      access: requiredLogin: true
    #.otherwise redirectTo: '/login'

.run ($rootScope, $location, AuthService) ->
  $rootScope.$on '$routeChangeStart', (event, nextRoute, currentRoute) ->
    if nextRoute.access.requiredLogin and !AuthService.isLogged
      $location.path '/login'