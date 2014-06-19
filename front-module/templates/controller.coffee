'use strict'

angular.module('<%= _.camelize(appName) %>App')
.config ($routeProvider) ->
  $routeProvider.when '/<%= moduleCamelName %>',
    templateUrl: 'modules/<%= moduleCamelName %>'
    controller: '<%= moduleName %>Ctrl'
.controller '<%= moduleName %>Ctrl', ($scope) ->
  