express    = require 'express'
path       = require "path"
fs         = require "fs"

module.exports = serve = ->
  app = express()
  app.use(express.static(path.join(__dirname, 'www')))

  app.listen 3000, ->

serve()
