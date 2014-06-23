'use strict'

module.exports =
  env: 'development'
  ip: '0.0.0.0'
  mongo:
    uri: 'mongodb://localhost/<%= _.camelize(config.appName) %>'