'use strict'

class MainController

angular.module('<%= _.camelize(config.appName) %>App')
.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'modules/main'
    controller: 'MainController'
    controllerAs: 'ctrl'
    reloadOnSearch: false
.controller 'MainController', MainController