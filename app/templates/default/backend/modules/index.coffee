'use strict'

middleware = require './../middleware'
path = require 'path'

#send Ppartial, or 404
partials = (req, res) ->
  stripped = req.url.split('.')[0]
  requestedView = path.join './', stripped
  res.render requestedView, (err, html) ->
    if err
      console.log "Error rendering partial #{requestedView}\n", err
      res.send 404
    else
      res.send html

#send our single page app
index = (req, res) ->
  res.render 'index'

module.exports = (app) ->
  app.route '/modules/*'
    .get partials
  app.route '/*'
    .get middleware.setUserCookie, index