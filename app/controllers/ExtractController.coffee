Extractor = require '../services/Extractor'

module.exports = new class ExtractController

  index: (req, res) ->

    unless req.query.url
      message = 'You must include a `url` parameter in the query string.'
      return res.status(400).json error: { message: message }

    extractor = new Extractor req.query.url

    extractor.fetch (err, statusCode, data) ->
      if err
        res.status(statusCode).json err
      else
        res.json data
