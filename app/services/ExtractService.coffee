URI = require 'urijs'
request = require 'request'
unfluff = require 'unfluff'

module.exports = new class ExtractService

  transformUrl: (url) ->

    url = URI.parse decodeURIComponent url

    unless url.protocol
      url.protocol = 'http'

    URI.build url

  fetchUrl: (url, callback) ->

    request url, (err, res, body) ->

      if err
        return callback { error: { message: 'Badly formatted URL.'} }, 400, null

      if res.statusCode isnt 200
        err = error: { message: 'There was a problem fetching the URL.' }
        return callback err, res.statusCode, null

      callback err, res.statusCode, unfluff body
