mysql = require 'mysql'
SALT_WORK_FACTOR = 10
mysqlOptions = {}

connection = mysql.createConnection
  host: 'localhost'
  database: 'test-app'
  user: 'root'
  password: 'root'
  port: 3306

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
