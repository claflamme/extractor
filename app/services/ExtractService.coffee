URI = require 'urijs'
request = require 'request'
unfluff = require 'unfluff'

module.exports = new class ExtractService

  imageTypes: ['jpg', 'jpeg', 'gif', 'png']

  transformUrl: (url) ->

    url = URI.parse decodeURIComponent url

    unless url.protocol
      url.protocol = 'http'

    URI.build url

  fetchUrl: (url, callback) ->

    request url, (err, res, body) =>

      if err
        return callback { error: { message: 'Badly formatted URL.'} }, 400, null

      if res.statusCode isnt 200
        err = error: { message: 'There was a problem fetching the URL.' }
        return callback err, res.statusCode, null

      @parseResponse url, res, body, callback

  parseResponse: (url, res, body, callback) ->

    contentType = res.headers['content-type'].split '/'
    isImage = @imageTypes.some (imageType) ->
      contentType[1] is imageType

    data = unfluff body

    if isImage
      data.image = url

    callback null, res.statusCode, data
