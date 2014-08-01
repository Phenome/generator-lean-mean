'use strict'

path = require 'path'
fs = require 'fs'

module.exports = (app) ->
  fs.readdir "#{__dirname}/modules", (err, files) ->
    if err then return
    for file in files
      continue if file.search(/\.coffee$/) is -1 or file is 'index.coffee'
      require(path.resolve "#{__dirname}/modules/#{file}") app
    require(path.resolve "#{__dirname}/modules/index.coffee") app