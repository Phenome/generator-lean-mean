'use strict'

angular.module('<%= _.camelize(config.appName) %>App')
.controller 'NavbarCtrl', ($scope, $location) ->
  $scope.modules = [
    name:"Home"
    path:"/"
   #---begin:modules---#
   #---end:modules---#
  ]
  $scope.isActive = (route) ->
    route is $location.path()
  return
  