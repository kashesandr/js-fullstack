fs = require "fs"
winston = require "winston"
path = require "path"
db = require './database-controller'
jwt = require 'jsonwebtoken'
tokenManager = require './token-manager'
GLOBAL_CONFIGS = JSON.parse(fs.readFileSync(path.join __dirname, 'configs.json'), 'utf8')
SECRET_TOKEN = GLOBAL_CONFIGS.secretToken

module.exports =

  login: (req, res) ->
    username = req.body.username or ''
    password = req.body.password or ''
    return res.sendStatus 401 if username is '' or password is ''

    db.user.findOne({username: username})
    .then (user) ->
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
    db.user.findAll()
    .then (result) ->
      res.json result: result

  addUser: (req, res) ->
    tokenManager.verifyToken req, res, ->
      db.user.addUser(req.body)
      .then (result) ->
        res.json result: result

  updateUser: (req, res) ->
    tokenManager.verifyToken req, res, ->
      db.user.updateUser(req.body)
      .then (result) ->
        res.json result: result

  deleteUser: (req, res) ->
    tokenManager.verifyToken req, res, ->
      id = req.params.id
      db.user.deleteUser(id)
      .then (result) ->
        res.json result: result

  checkUser: (req, res) ->
    tokenManager.verifyToken req, res, (d) ->
      username = req.params.username or ''
      db.user.checkUser(username)
      .then (result) ->
        res.json result: result.length > 0