'use strict'
<% if (config.mongoose) { %>
mongoose = require 'mongoose'

Schema = mongoose.Schema

ThingSchema = new Schema
  name: String
  info: String
  link: String

module.exports = mongoose.model 'Thing', ThingSchema
<% } else { %>
module.exports =
  # Simulating mongoose model
  find: (cb) ->
    cb null, [
      id: 0
      name: 'CoffeeScript'
      info: 'CoffeeScript is a little language that compiles into JavaScript. Underneath that awkward Java-esque patina, JavaScript has always had a gorgeous heart. CoffeeScript is an attempt to expose the good parts of JavaScript in a simple way.'
      link: 'http://coffeescript.org/'
    ,
      id: 1
      name: 'Jade'
      info: 'Jade is a high performance template engine heavily influenced by Haml and implemented with JavaScript for node and browsers.'
      link: 'http://jade-lang.com/'
    ,
      id: 2
      name: 'Stylus'
      info: 'Stylus is a revolutionary new language, providing an efficient, dynamic, and expressive way to generate CSS. Supporting both an indented syntax and regular CSS style.'
      link: 'https://learnboost.github.io/stylus'
    ]
<% } %>
