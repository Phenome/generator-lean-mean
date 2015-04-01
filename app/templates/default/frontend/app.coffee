'use strict'

angular.module('<%= _.camelize(config.appName) %>App', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngAnimate',<% if (config.css === 'AngularMaterial') { %> 
  'ngMaterial' <% } %>
])
  .config ($locationProvider) ->
    $locationProvider.html5Mode true