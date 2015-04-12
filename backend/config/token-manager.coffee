client = require 'mysql'

TOKEN_EXPIRATION = 60
TOKEN_EXPIRATION_SEC = TOKEN_EXPIRATION * 60

# token verification

verifyToken = (req, res, next) ->
  token = getToken(req.headers)
  client.get token, (err, reply) ->
    if err
      console.log err
      return res.send(500)
    if reply
      res.send 401
    else
      next()
    return
  return

expireToken = (headers) ->
  token = getToken(headers)
  if token != null
    client.set token, is_expired: true
    client.expire token, TOKEN_EXPIRATION_SEC
  return

getToken = (headers) ->
  if headers and headers.authorization
    authorization = headers.authorization
    part = authorization.split(' ')
    if part.length == 2
      token = part[1]
      part[1]
    else
      null
  else
    null

module.exports = {
  TOKEN_EXPIRATION
  TOKEN_EXPIRATION_SEC
  verifyToken
  expireToken
}