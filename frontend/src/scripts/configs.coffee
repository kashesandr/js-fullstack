'use strict'

app = angular.module 'App'

.config ($httpProvider, $routeProvider) ->
  $httpProvider.interceptors.push 'TokenInterceptor'
  $routeProvider
    .when '/',
      templateUrl: 'scripts/pages/main/template.html'
      controller: 'mainController'
      access: requiredLogin: false
    .when '/edit',
      templateUrl: 'scripts/pages/main/template.html'
      controller: 'mainController'
      access: requiredLogin: true
    .when '/login',
      templateUrl: 'scripts/pages/login/template.html'
      controller: 'loginController'
      access: requiredLogin: false
    .when '/logout',
      templateUrl: 'scripts/pages/logout/template.html'
      controller: 'logoutController'
      access: requiredLogin: true
    .when '/404',
      templateUrl: 'scripts/pages/404/template.html'
      controller: '404Controller'
      access: requiredLogin: false
    .otherwise redirectTo: '/404'

.factory 'API_URL', (GLOBAL_CONFIGS) ->
  API = GLOBAL_CONFIGS.api
  return "#{API.protocol}#{API.host}:#{API.port}#{API.url}"

