redis = require 'redis'
redisClient = redis.createClient 6379

redisClient.on 'error', (error) ->
  console.log "Redis error: #{error}"

redisClient.on 'connect', () ->
  console.log "Redis is ready"

TOKEN_EXPIRATION = 60
TOKEN_EXPIRATION_SEC = TOKEN_EXPIRATION * 60

# token verification

getToken = (headers) ->
  if headers and headers.authorization
    authorization = headers.authorization
    part = authorization.split(' ')
    if part.length == 2
      token = part[1]
      part[1]

verifyToken = (req, res, callback) ->
  token = getToken req.headers
  redisClient.get token, (err, reply) ->
    if err
      return res.send 500
    if reply or !token
      res.send 401
    else
      callback()

expireToken = (headers) ->
  token = getToken headers
  if token != null
    redisClient.set token, is_expired: true
    redisClient.expire token, TOKEN_EXPIRATION_SEC
  return

module.exports = {
  TOKEN_EXPIRATION
  TOKEN_EXPIRATION_SEC
  verifyToken
  expireToken
}