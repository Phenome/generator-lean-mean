'use strict'

class NavbarController
  constructor: (@location) ->
    @modules = [
      name:"Home"
      path:"/"
    #---begin:modules---#
    #---end:modules---#
    ]
  isActive: (route) ->
    route is @location.path()

NavbarController.$inject = ['$location']

angular.module('<%= _.camelize(config.appName) %>App')
.controller 'NavbarController', NavbarController
  