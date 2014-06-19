'use strict';

_ = require 'lodash'

module.exports = _.merge(
 require './env/all.coffee'
 require './env/' + process.env.NODE_ENV + '.coffee' || {}
 )