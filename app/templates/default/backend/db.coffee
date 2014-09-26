'use strict'
config = require './config/config'
pmongo = require 'promised-mongo'
mongo = pmongo config.mongo.uri

oid = (id) ->
  try
    _oid = pmongo.ObjectId id
  catch e
    _oid = id
  _oid  

module.exports = {oid, mongo}