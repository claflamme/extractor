URI = require 'urijs'
request = require 'request'
unfluff = require 'unfluff'
cheerio = require 'cheerio'
OEmbedExtractor = require './OEmbedExtractor'

module.exports = class Extractor

  constructor: (url) ->

    @setUrl url

  url: null

  imageTypes: ['jpg', 'jpeg', 'gif', 'png']

  errors:
    badUrl: message: 'Badly formatted URL. Make sure it is correctly encoded.'
    server: message: 'There was a problem fetching the URL.'

  setUrl: (url) ->

    @url = @transformUrl url

  transformUrl: (url) ->

    url = URI.parse decodeURIComponent url

    unless url.protocol
      url.protocol = 'http'

    URI.build url

  fetch: (callback) ->

    request @url, (err, res, body) =>

      if err
        return callback { error: @errors.badUrl }, 400, null

      if res.statusCode isnt 200
        return callback { error: @errors.server }, res.statusCode, null

      @parseResponse res, body, callback

  parseResponse: (res, body, callback) ->

    output =
      type: 'link'
      version: 1.0

    contentType = res.headers['content-type'].split '/'
    isImage = @imageTypes.some (imageType) ->
      contentType[1] is imageType

    if isImage
      output.type = 'photo'
      output.url = @url
      callback null, 200, output
    else
      oEmbedExtractor = new OEmbedExtractor body
      oEmbedExtractor.extract (oEmbedData) ->
        if oEmbedData
          output = oEmbedData
        else
          data = unfluff.lazy body
          output.title = data.title()
          output.description = data.description()
          output.thumbnail_url = data.image()
          output.provider_url = data.canonicalLink()
        callback null, 200, output
