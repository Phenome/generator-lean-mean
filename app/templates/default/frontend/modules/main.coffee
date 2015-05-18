'use strict'

class MainController
  constructor: (http) ->

    http.get '/api/things'
    .success (data) =>
      @things = data

MainController.$inject = ['$http']

angular.module('<%= _.camelize(config.appName) %>App')
.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'modules/main'
    controller: 'MainController'
    controllerAs: 'ctrl'
    reloadOnSearch: false
.controller 'MainController', MainController
