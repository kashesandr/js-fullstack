fs = require "fs"
winston = require "winston"
express = require 'express'
jwt = require 'express-jwt'
bodyParser = require 'body-parser' # bodyparser + json + urlencoder
morgan = require 'morgan' # logger
path = require "path"
GLOBAL_CONFIGS = JSON.parse(fs.readFileSync(path.join(__dirname, "..", 'settings.json')), 'utf8').GLOBAL_CONFIGS
CONFIGS = JSON.parse(fs.readFileSync(path.join __dirname, 'configs.json'), 'utf8')

API = GLOBAL_CONFIGS.api
SECRET_TOKEN = CONFIGS.secretToken
HOSTNAME = API.host
PORT = process.argv[2] || API.port
rootPath = path.join __dirname, ".."
frontEndPath = path.join rootPath, 'frontend', 'build'

app = express()
app.use express.static frontEndPath
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
app.get '/logout', jwt(secret: SECRET_TOKEN), routes.logout

# Get all users
app.get '/api/users', routes.getAll

# Add a user
app.post '/api/users', routes.addUser

# Update user
app.put '/api/users/:id', routes.updateUser

# Delete user
app.delete '/api/users/:id', routes.deleteUser

# Check whether user exists or not
app.get '/api/checkuser/:username', routes.checkUser

winston.info "API is starting on port #{PORT}"
