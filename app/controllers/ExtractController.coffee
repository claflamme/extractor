ExtractService = require '../services/ExtractService'

module.exports = new class ExtractController

  index: (req, res) ->

    unless req.query.url
      message = 'You must include a `url` parameter in the query string.'
      return res.status(400).json error: { message: message }

    url = ExtractService.transformUrl req.query.url

    ExtractService.fetchUrl url, (err, statusCode, data) ->
      if err
        res.status(statusCode).json err
      else
        res.json data
