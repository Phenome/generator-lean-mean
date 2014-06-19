'use strict'

path = require 'path'

#send Ppartial, or 404
exports.partials = (req, res) ->
  stripped = req.url.split('.')[0]
  requestedView = path.join './', stripped
  res.render requestedView, (err, html) ->
    if err
      console.log "Error rendering partial #{requestedView}\n", err
      res.send 404
    else
      res.send html

#send our single page app
exports.index = (req, res) ->
  res.render 'index'