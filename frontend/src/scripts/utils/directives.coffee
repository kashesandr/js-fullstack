'use strict'

app = angular.module 'App'

app.directive 'compareTo', ->
    require: "ngModel"
    scope:
        otherModelValue: "=compareTo"
    link: (scope, element, attributes, ngModel) ->
        ngModel.$validators.compareTo = (modelValue) ->
            modelValue == scope.otherModelValue
        scope.$watch "otherModelValue", ->
            ngModel.$validate()

app.directive 'isUniqueName', (dataService, $q) ->
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->
        ngModel.$asyncValidators.username = (modelValue, viewValue) ->
            dataService.userExists(viewValue)
            .then (result) ->
                if result.result
                    return $q.reject()
                return true