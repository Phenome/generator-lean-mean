'use strict'

describe 'Controller: MainController', ->
  # load the controller's module
  beforeEach module('<%= _.camelize(config.appName) %>App')

  MainCtrl = null
  $httpBackend = null

  # Initialize the controller and a mock scope
  beforeEach(inject( (_$httpBackend_, $controller) ->
    $httpBackend = _$httpBackend_
    $httpBackend.expectGET '/api/things'
      .respond [
        name: 'CoffeeScript'
        info: 'CoffeeScript is a little language that compiles into JavaScript. Underneath that awkward Java-esque patina, JavaScript has always had a gorgeous heart. CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way.'
        link: 'http://coffeescript.org/'
      ,
        name: 'Jade'
        info: 'Jade is a high performance template engine heavily influenced by Haml and implemented with JavaScript for node and browsers.'
        link: 'http://jade-lang.com/'
      ,
        name: 'Stylus'
        info: 'Stylus is a revolutionary new language, providing an efficient, dynamic, and expressive way to generate CSS. Supporting both an indented syntax and regular CSS style.'
        link: 'https://learnboost.github.io/stylus'
      ]

    MainCtrl = $controller 'MainController'
  ))

  it 'should attach a list of things to the scope', (done) ->
    $httpBackend.flush()
    expect(MainCtrl.things.length).toBe 3
    done()

  it 'should attach a list of things with the right properties', (done) ->
    $httpBackend.flush()

    for thing in MainCtrl.things
      expect(thing.hasOwnProperty('name')).toBe true
      expect(thing.hasOwnProperty('info')).toBe true
      expect(thing.hasOwnProperty('link')).toBe true
    done()
