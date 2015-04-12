db = require('../config/mysql-database')
jwt = require('jsonwebtoken')
secret = require('../config/secret')
tokenManager = require('../config/token-manager')

login = (req, res) ->
  console.log "[req]: #{req}"
  username = req.body.username or ''
  password = req.body.password or ''
  if username == '' or password == ''
    return res.send(401)

  ###
  db.userModel.findOne { username: username }, (err, user) ->
    if err
      console.log err
      return res.send(401)
    if user == undefined
      return res.send(401)
    user.comparePassword password, (isMatch) ->
      if !isMatch
        console.log 'Attempt failed to login with ' + user.username
        return res.send(401)
      token = jwt.sign({ id: user._id }, secret.secretToken, expiresInMinutes: tokenManager.TOKEN_EXPIRATION)
      res.json token: token
  ###

logout = (req, res) ->
  if req.user
    tokenManager.expireToken req.headers
    delete req.user
    res.send 200
  else
    res.send 401

module.exports = {
  login
  logout
}
