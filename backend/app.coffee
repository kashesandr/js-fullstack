fs = require 'fs'
CONFIGS = JSON.parse fs.readFileSync './settings.json', 'utf8'
DbController = require './db-controller'

module.exports = ->
    console.log "server side works"
