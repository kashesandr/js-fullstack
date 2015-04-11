fs = require 'fs'
CONFIGS = JSON.parse fs.readFileSync './settings.json', 'utf8'
moment = require 'moment'

DbController = {}

module.exports = DbController