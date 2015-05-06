fs = require "fs"
winston = require "winston"
path = require "path"
db = require './database-controller'
jwt = require 'jsonwebtoken'
tokenManager = require './token-manager'
GLOBAL_CONFIGS = JSON.parse(fs.readFileSync(path.join __dirname, 'configs.json'), 'utf8')
SECRET_TOKEN = GLOBAL_CONFIGS.secretToken

returnJsonResult = (error, res, result) ->
  winston.error "ROUTES: Error returning JSON(#{result}) - #{error}" if error
  res.json result: result

module.exports =

  login: (req, res) ->
    username = req.body.username or ''
    password = req.body.password or ''
    return res.sendStatus 401 if username == '' or password == ''

    db.user.findOne { username: username }, (error, user) ->
      if error or user is undefined
        winston.error "#{error}"
        return res.sendStatus 401

      if password is user.password
        token = jwt.sign(
          { id: user.id },
          SECRET_TOKEN,
          expiresInMinutes: tokenManager.TOKEN_EXPIRATION
        )
        winston.info "Logged in as #{user.username}"
        res.json token: token
      else
        winston.error "Attempt failed to log in as #{user.username}"
        res.sendStatus 401

  logout: (req, res) ->
    if req.user
      tokenManager.expireToken req.headers
      delete req.user
      winston.info "Logged out"
      res.sendStatus 200
    else
      res.sendStatus 401

  getAll: (req, res) ->
    db.user.findAll (error, result) ->
      returnJsonResult error, res, result

  addUser: (req, res) ->
    tokenManager.verifyToken req, res, ->
      db.user.addUser req.body, (error, result) ->
        returnJsonResult error, res, result

  updateUser: (req, res) ->
    tokenManager.verifyToken req, res, ->
      db.user.updateUser req.body, (error, result) ->
        returnJsonResult error, res, result

  deleteUser: (req, res) ->
    tokenManager.verifyToken req, res, ->
      id = req.params.id
      db.user.deleteUser id, (error, result) ->
        returnJsonResult error, res, result

  checkUser: (req, res) ->
    tokenManager.verifyToken req, res, (d) ->
      username = req.params.username or ''
      db.user.checkUser username, (error, result) ->
        winston.error "ROUTES: error checking a user #{username} - #{error}"
        res.json {result: result.length > 0}