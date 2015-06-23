'use strict'

Thing = require './thing.model'

index = (req, res) ->
  Thing.find (err, things) ->
    if err
      return res.status(500).send err

    res.status(200).json things

module.exports = (app) ->
  app.route '/api/things'
    .get index
