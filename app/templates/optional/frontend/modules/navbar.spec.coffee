'use strict'

describe 'Controller: NavbarController', ->
  # load the controller's module
  beforeEach module('<%= _.camelize(config.appName) %>App')

  NavbarCtrl = null

  # Initialize the controller and a mock scope
  beforeEach(inject( ($controller) ->
    NavbarCtrl = $controller 'NavbarController'
  ))

  it 'should attach a list of modules with the right properties', (done) ->

    for module in NavbarCtrl.modules
      expect(module.hasOwnProperty('name')).toBe true
      expect(module.hasOwnProperty('path')).toBe true
    done()
