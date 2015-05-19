'use strict'

describe 'Controller: <%= moduleName %>Controller', ->
  # load the controller's module
  beforeEach module('<%= _.camelize(config.appName) %>App')

  <%= moduleName %>Ctrl = null

  # Initialize the controller and a mock scope
  beforeEach(inject( ($controller) ->
    <%= moduleName %>Ctrl = $controller '<%= moduleName %>Controller'
  ))

  it 'should have a property name with the name of the module', (done) ->
    expect(<%= moduleName %>Ctrl.name).toBe '<%= moduleName %>'
    done()
