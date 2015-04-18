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
    }, (error, result) ->
      callback error, result[0]

  findAll: (callback) ->
    connection.query {
      sql: "SELECT * FROM users"
    }, (error, results) ->
      callback error, results

  addUser: (user, callback) ->
    connection.query {
      sql: "INSERT INTO users (`username`, `password`, `firstname`, `lastname`, `street`, `zip`, `location`) VALUES (?, ?, ?, ?, ?, ?, ?)",
      values: [
        user.username
        user.password
        user.firstname
        user.lastname
        user.street || ''
        user.zip || ''
        user.location || ''
      ]
    }, (error, result) ->
      callback error, result

  updateUser: (user, callback) ->
    id = user.id
    callback(throw new Error "Error updating user, no id specified") if !id
    connection.query {
      sql: "UPDATE users SET username=?, password=?, firstname=?, lastname=?, street=?, zip=?, location=? WHERE id=#{id}",
      values: [
        user.username
        user.password
        user.firstname
        user.lastname
        user.street || ''
        user.zip || ''
        user.location || ''
      ]
    }, (error, result) ->
      callback error, result

  deleteUser: (userId, callback) ->
    connection.query {
      sql: "DELETE FROM users where id = ?",
      values: [userId]
    }, (error, result) ->
      callback error, result

  checkUser: (username, callback) ->
    connection.query {
      sql: "SELECT username FROM users WHERE username = ?"
      values: [username]
    }, (error, result) ->
      callback error, result

module.exports = {
  user
}
