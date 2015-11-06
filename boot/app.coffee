require('dotenv').load()
express = require 'express'
bodyParser = require 'body-parser'
app = express()

app.use (req, res, next) ->
  if req.query.secret isnt process.env.SECRET_KEY
    res.sendStatus 401
  else
    next()
    
app.use '/', require '../app/router'

server = app.listen process.env.PORT, ->
  console.log 'Listening on port %s', server.address().port
