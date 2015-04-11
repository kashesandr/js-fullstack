'use strict'

app = angular.module "App"

app.directive 'login', () ->
    directive =
        templateUrl: "scripts/pages/login/template.html"
        controller: "loginController"
