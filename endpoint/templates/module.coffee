'use strict'
db = require './../db'
db.mongo.<%= moduleCamelName %> = db.mongo.collection '<%= moduleCamelName %>'

transformId = (obj) ->
  fn = (o) ->
    o._id = db.oid o._id if o?._id
    o
  if obj instanceof Array
    obj.map fn
  else
    fn obj

get = (req, res) ->
  promise = if not id = req.params.id
    db.mongo.<%= moduleCamelName %>.find().toArray()
  else
    db.mongo.<%= moduleCamelName %>.findOne _id:db.oid id
  promise.then (obj) ->
    res.json obj
  , (err) ->
    res.status 500
    .json err
save = (req, res) ->
  db.mongo.<%= moduleCamelName %>.save transformId req.body
  .then ->
    res
    .status 200
    .end()
remove = (req, res) ->
  id = res.params.id or req.body.id
  id = db.oid id
  db.mongo.<%= moduleCamelName %>.remove _id:id
  .then ->
    res
    .status 200
    .send()

module.exports = (app) ->
  app.route '/api/<%= moduleCamelName %>/:id?'
    .get get
    .put save
    .post save
    .delete remove