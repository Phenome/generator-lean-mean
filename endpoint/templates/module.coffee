'use strict'
db = require './../db'
db.mongo.<%= moduleCamelName %> = db.mongo.collection '<%= moduleCamelName %>'

get = (req, res) ->
  promise = if not id = req.params.id
    db.mongo.<%= moduleCamelName %>.find().toArray()
  else
    db.mongo.<%= moduleCamelName %>.findOne _id:db.oid id
  promise.then (obj) ->
    res.json obj
  , (err) ->
    res.json 500, err
save = (req, res) ->
  db.mongo.<%= moduleCamelName %>.save req.body
  .then ->
    res.send 200
remove = (req, res) ->
  id = res.params.id or req.body.id
  id = db.oid id
  db.mongo.<%= moduleCamelName %>.remove _id:id
  .then ->
    res.send 200

module.exports = (app) ->
  app.route '/api/<%= moduleCamelName %>/:id?'
    .get get
    .put save
    .post save
    .delete remove