'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

express = require 'express'
path = require 'path'
fs = require 'fs'
config = require './backend/config/config'
<% if (config.mongoose) { %>
mongoose = require 'mongoose'
# Connect to database
mongoose.connect config.mongo.uri, config.mongo.options
mongoose.connection.on 'error', (err) ->
  console.error 'MongoDB connection error: ' + err
  process.exit -1
<% } %>
# Server
app = express()
require('./backend/config/express') app
require('./backend/routes') app

# Start server
app.listen config.port, config.ip, ->
  console.log 'Express server listening on %s:%d, in %s mode', config.ip, config.port, app.get 'env'

# Expose app
exports = module.exports = app
