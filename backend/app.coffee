express = require 'express'
app = express()
jwt = require 'express-jwt'
bodyParser = require 'body-parser' # bodyparser + json + urlencoder
morgan = require 'morgan' # logger
tokenManager = require './config/token-manager'
secret = require './config/secret'
path = require "path"
root = path.join __dirname, ".."
frontend = path.join root, 'frontend', 'build'

hostname = process.env.HOSTNAME || 'localhost'
PORT = 3001

app.use express.static frontend
app.use bodyParser()
app.use bodyParser.urlencoded extended: true
app.use morgan()
app.listen PORT, hostname

#Routes
routes = {}
routes.users = require './route/users'

app.all '*', (req, res, next) ->
  res.set 'Access-Control-Allow-Origin', 'http://localhost'
  res.set 'Access-Control-Allow-Credentials', true
  res.set 'Access-Control-Allow-Methods', 'GET, POST, DELETE, PUT'
  res.set 'Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Authorization'
  if 'OPTIONS' == req.method
    return res.send(200)
  next()

#Login
app.post '/login', routes.users.login

#Logout
app.get '/logout', jwt(secret: secret.secretToken), routes.users.logout

app.get '/api/users', routes.users.getAll

console.log "API is starting on port #{PORT}"
