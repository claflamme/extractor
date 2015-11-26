cheerio = require 'cheerio'

module.exports = class OEmbedExtractor

  constructor: (@html) ->

  extract: (callback) ->

    oEmbedUrl = @findOEmbedUrl cheerio.load @html

    if oEmbedUrl
      request oEmbedUrl, (err, res, body) ->
        callback JSON.parse body
    else
      callback null

  findOEmbedUrl: ($) ->

    url = null

    $('link').each (i, link) ->

      attributes = $(link).attr()

      if attributes.type is 'application/json+oembed'
        url = attributes.href
        return false

    return url
