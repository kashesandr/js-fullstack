db = require('../config/mysql-database')
jwt = require('jsonwebtoken')
secret = require('../config/secret')
tokenManager = require('../config/token-manager')

login = (req, res) ->
  username = req.body.username or ''
  password = req.body.password or ''
  if username == '' or password == ''
    return res.send(401)

  db.user.findOne { username: username }, (error, user) ->
    if error
      console.log "#{error}"
      return res.send(401)

    if user is undefined
      return res.send(401)

    if password is user.password
      console.log "Logged in as #{user.username}"
      token = jwt.sign(
        { id: user.id },
        secret.secretToken,
        expiresInMinutes: tokenManager.TOKEN_EXPIRATION
      )
      res.json token: token
    else
      console.log "Attempt failed to login with #{user.username}"
      return res.send 401

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
