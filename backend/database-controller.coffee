fs = require "fs"
winston = require "winston"
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
    winston.error "Connection refused to mysql: #{error.stack}"
    winston.error error
  else
    winston.info "Connection successful to mysql: id is #{connection.threadId}"

queryAll = (sql, values, callback) ->
  connection.query {
    sql: sql
    values: values
  }, (error, result) ->
    callback error, result

query = (sql, values, callback) ->
  queryAll sql, values, (error, results) ->
    callback error, results[0]

user =
  findOne: (obj, callback) ->
    key = null
    value = null
    for k, v of obj
      key = k
      value = v
    sql = "SELECT * FROM users where #{key} = ?"
    values = [value]
    query sql, values, callback

  findAll: (callback) ->
    sql = "SELECT * FROM users"
    values = []
    queryAll sql, values, callback

  addUser: (user, callback) ->
    sql = """
      INSERT
      INTO users (`username`, `password`, `firstname`, `lastname`, `street`, `zip`, `location`)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    """
    values = [
      user.username
      user.password
      user.firstname
      user.lastname
      user.street || ''
      user.zip || ''
      user.location || ''
    ]
    queryAll sql, values, callback

  updateUser: (user, callback) ->
    id = user.id
    callback(throw new Error "Error updating user, no id specified") if !id
    sql = """
      UPDATE
      users SET username=?, password=?, firstname=?, lastname=?, street=?, zip=?, location=?
      WHERE id=#{id}
    """
    values = [
      user.username
      user.password
      user.firstname
      user.lastname
      user.street || ''
      user.zip || ''
      user.location || ''
    ]
    queryAll sql, values, callback

  deleteUser: (userId, callback) ->
    sql = "DELETE FROM users where id = ?"
    values = [userId]
    queryAll sql, values, callback

  checkUser: (username, callback) ->
    sql = "SELECT username FROM users WHERE username = ?"
    values = [username]
    queryAll sql, values, callback

module.exports = {
  user
}
