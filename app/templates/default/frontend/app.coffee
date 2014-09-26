'use strict'

angular.module('<%= _.camelize(config.appName) %>App', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngAnimate'
])
  .config ($routeProvider, $locationProvider, $httpProvider, $provide) ->
    $routeProvider
      .when '/',
        templateUrl: 'modules/main'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
    $provide.provider 'api', jelbourn.ApiProvider
  .config (apiProvider) ->
    #---begin:endpoints---#
    #---end:endpoints---#