'use strict'

app = angular.module "App"

app.directive 'main', () ->
    directive =
        templateUrl: "scripts/main/template.html"
        controller: "mainController"
