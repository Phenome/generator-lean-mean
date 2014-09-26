'use strict'

get = (req, res) ->
  res.send "This is the <%= moduleCamelName %> module."

module.exports = (app) ->
  app.route '/api/<%= moduleCamelName %>/:id?'
    .get get