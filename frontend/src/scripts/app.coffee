'use strict'

app = angular

.module 'App',
  ['angularMoment', 'ui.bootstrap', 'GlobalConfigs', 'UserService', 'AuthService']

.config ($httpProvider) ->
  $httpProvider.interceptors.push 'TokenInterceptor'

.config ($location, $routeProvider) ->
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
    .otherwise redirectTo: '/'

.run ($rootScope, $location, AuthService) ->
  $rootScope.$on '$routeChangeStart', (event, nextRoute, currentRoute) ->
    if nextRoute.access.requiredLogin and !AuthService.isLogged
      $location.path '/login'