unfluff = require 'unfluff'
request = require 'request'

module.exports = new class ExtractController

  index: (req, res) ->

    unless req.query.url
      message = 'You must include a `url` parameter in the query string.'
      return res.status(400).json error: { message: message }

    url = decodeURIComponent req.query.url
    console.log '--> Requesting %s', url

    request url, (err, httpResponse, body) ->
      if err
        console.error err

      if httpResponse.statusCode is 200
        data = unfluff body
        res.json data
      else
        console.log httpResponse.statusCode
        res.sendStatus httpResponse.statusCode
