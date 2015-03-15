path = require 'path'
express = require 'express'
favicon = require 'static-favicon'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
errorHandler = require 'errorhandler'
config = require './config'


module.exports = (app) ->
  env = app.get 'env'
  if env is 'development'
    app
    .use require('connect-livereload')()
    .use errorHandler()

    #disables caching of scripts in development module
    #TODO: only for certain paths?
    .use (req, res, next) ->
      if req.url.search(/\.js$/) isnt -1 and req.url.search(/bower_components/) is -1
        res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
        res.header 'Pragma', 'no-cache'
        res.header 'Expires', 0
      next()

  app
  .use express.static path.join config.root, '.tmp'
  .use express.static path.join config.root, 'frontend'
  .set 'views', "#{config.root}/frontend"
  .set 'view engine', 'jade'
  .use cookieParser()
  .use bodyParser.urlencoded extended: false
  .use bodyParser.json()