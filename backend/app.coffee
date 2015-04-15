fs = require "fs"
express = require 'express'
app = express()
jwt = require 'express-jwt'
bodyParser = require 'body-parser' # bodyparser + json + urlencoder
morgan = require 'morgan' # logger
tokenManager = require './token-manager'
secret = require './secret'
path = require "path"
root = path.join __dirname, ".."
GLOBAL_CONFIGS = JSON.parse(fs.readFileSync(path.join(__dirname, "..", 'settings.json')), 'utf8').GLOBAL_CONFIGS
API = GLOBAL_CONFIGS.api

HOSTNAME = API.host
PORT = process.argv[2] || API.port
frontendFolder = path.join root, 'frontend', 'build'

app.use express.static frontendFolder
app.use bodyParser()
app.use bodyParser.urlencoded extended: true
app.use morgan()
app.listen PORT, HOSTNAME

# Routes
routes = require './routes'

app.all '*', (req, res, next) ->
  res.set 'Access-Control-Allow-Origin', "http://#{HOSTNAME}"
  res.set 'Access-Control-Allow-Credentials', true
  res.set 'Access-Control-Allow-Methods', 'GET, POST, DELETE, PUT'
  res.set 'Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Authorization'
  if 'OPTIONS' == req.method
    return res.send(200)
  next()

# Login
app.post '/login', routes.login

# Logout
app.get '/logout', jwt(secret: secret.secretToken), routes.logout

# Get all users
app.get '/api/users', routes.getAll

# Add a user
app.post '/api/users', routes.addUser

console.log "API is starting on port #{PORT}"
