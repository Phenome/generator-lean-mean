'use strict';

path = require 'path'

rootPath = path.normalize __dirname + '/../../..'

module.exports =
  root: rootPath
  port: process.env.PORT || 9000
  mongo:
    options:
      db:
        safe: true