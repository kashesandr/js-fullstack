fs = require "fs"
winston = require "winston"
path = require "path"
mysql = require 'mysql'
Q = require 'q'
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

queryDeferred = (sql, values) ->
  deferred = Q.defer()
  connection.query {
    sql: sql
    values: values
  }, (error, result) ->
    if error or !result
      winston.error "DB-CONTROLLER: error when processing a query (#{sql}): #{error}"
      return deferred.reject error
    deferred.resolve result
  deferred.promise

user =
  findOne: (obj) ->
    deferred = Q.defer()
    key = null
    value = null
    for k, v of obj
      key = k
      value = v
    sql = "SELECT * FROM users where #{key} = ? LIMIT 1"
    values = [value]
    queryDeferred(sql, values)
    .then (users) ->
      if users?.length? is 0
        return deferred.reject 'No users found.'
      deferred.resolve users[0]
    .catch (error) ->
      deferred.reject error
    deferred.promise

  findAll: ->
    sql = "SELECT * FROM users"
    values = []
    queryDeferred sql, values

  addUser: (user) ->
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
    queryDeferred sql, values

  updateUser: (user) ->
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
    queryDeferred sql, values

  deleteUser: (userId) ->
    sql = "DELETE FROM users where id = ?"
    values = [userId]
    queryDeferred sql, values

  checkUser: (username) ->
    sql = "SELECT username FROM users WHERE username = ?"
    values = [username]
    queryDeferred sql, values

module.exports = {
  user
}
