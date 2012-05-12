express = require 'express'
restler = require 'restler'
config = require './config'

app = express.createServer()
config.expressApp app,
  view_engine: "ejs"

app.get '/', (req, res) ->
  simperium_auth (simperium) ->
    res.render 'index',
      title: 'hello'
      app_id: process.env.SIMPERIUM_APP_ID
      access_token: simperium.access_token

simperium_auth = (cb) ->
  url = "https://auth.simperium.com/1/"+process.env.SIMPERIUM_APP_ID+"/authorize/"
  post_data = 
    username: process.env.SIMPERIUM_USERNAME
    password: process.env.SIMPERIUM_PASSWORD
  headers =
    'Content-Type': 'application/json'
    'X-Simperium-API-Key': process.env.SIMPERIUM_API_KEY
  restler.post(url, data: post_data, headers: headers, parser: restler.parsers.json).on 'complete', cb

app.listen(config.constants.port)
console.log "server started on localhost:#{config.constants.port}"
