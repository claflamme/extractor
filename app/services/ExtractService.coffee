URI = require 'urijs'
request = require 'request'
unfluff = require 'unfluff'
cheerio = require 'cheerio'

module.exports = new class ExtractService

  imageTypes: ['jpg', 'jpeg', 'gif', 'png']

  errors:
    badUrl: message: 'Badly formatted URL.'
    server: message: 'There was a problem fetching the URL.'

  transformUrl: (url) ->

    url = URI.parse decodeURIComponent url

    unless url.protocol
      url.protocol = 'http'

    URI.build url

  fetchUrl: (url, callback) ->

    request url, (err, res, body) =>

      if err
        return callback { error: @errors.badUrl }, 400, null

      if res.statusCode isnt 200
        return callback { error: @errors.server }, res.statusCode, null

      @parseResponse url, res, body, callback

  parseResponse: (url, res, body, callback) ->

    contentType = res.headers['content-type'].split '/'
    isImage = @imageTypes.some (imageType) ->
      contentType[1] is imageType

    data = unfluff body

    if isImage
      data.image = url

    @fetchOEmbedData res, body, data, callback

  fetchOEmbedData: (res, body, data, callback) ->

    oEmbedUrl = null
    $ = cheerio.load body

    $('link').each (i, link) ->
      attributes = $(link).attr()
      if attributes.type is 'application/json+oembed'
        oEmbedUrl = attributes.href
        return false

    if oEmbedUrl
      request oEmbedUrl, (err, res, body) ->
        data.oembed = JSON.parse body
        callback null, 200, data
    else
      callback null, 200, data
