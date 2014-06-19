'use strict';

express = require 'express'
path = require 'path'
fs = require 'fs'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

config = require './backend/config/config'
app = express()
require('./backend/config/express') app
require('./backend/routes') app

# Start server
app.listen config.port, config.ip, ->
  console.log 'Express server listening on %s:%d, in %s mode', config.ip, config.port, app.get 'env'

# Expose app
exports = module.exports = app;
