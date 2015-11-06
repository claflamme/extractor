express = require 'express'
router = express.Router()
ExtractController = require './controllers/ExtractController'

router.get '/', (req, res) ->
  res.send 'hi'

router.get '/extract', ExtractController.index

module.exports = router
