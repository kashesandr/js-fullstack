fs = require "fs"
path = require "path"
mysql = require 'mysql'
SALT_WORK_FACTOR = 10
CONFIGS = JSON.parse(fs.readFileSync(path.join __dirname, 'configs.json'), 'utf8').mysql

connection = mysql.createConnection
  host: CONFIGS.host
  database: CONFIGS.database
  user: CONFIGS.user
  password: CONFIGS.password
  port: CONFIGS.port

connection.connect (error) ->
  if error
    console.log "Connection refused to mysql: #{error.stack}"
    console.log error
  else
    console.log "Connection successful to mysql: id is #{connection.threadId}"

user =
  findOne: (obj, callback) ->
    key = null
    value = null
    for k, v of obj
      key = k
      value = v
    connection.query {
      sql: "SELECT * FROM users where #{key} = ?"
      values: [value]
    }, (error, results) ->
      callback error, results[0]

  findAll: (callback) ->
    connection.query {
      sql: "SELECT * FROM users"
    }, (error, results) ->
      callback error, results

module.exports = {
  user
}
