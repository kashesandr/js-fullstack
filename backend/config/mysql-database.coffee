mysql = require 'mysql'
bcrypt = require 'bcrypt'
SALT_WORK_FACTOR = 10
mysqlOptions = {}

connection = mysql.createConnection
  host: 'localhost'
  user: 'root'
  password: 'root'
  port: 3306

connection.connect (error) ->
  if error
    console.log "Connection refused to mysql: #{error.stack}"
    console.log error
  else
    console.log "Connection successful to mysql: id is #{connection.threadId}"

User = {}

module.exports =
  User
