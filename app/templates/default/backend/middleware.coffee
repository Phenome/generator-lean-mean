'use strict';

module.exports =
  #Protect routes on your api from unauthenticated access
  auth: (req, res, next) ->
    return next() if req.isAuthenticated()
    res.send 401
  
  #Set a cookie for angular so it knows we have an http session
  setUserCookie: (req, res, next) ->
    if req.user
      res.cookie 'user', JSON.stringify req.user.userInfo
    next()