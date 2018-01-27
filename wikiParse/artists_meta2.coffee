fs = require "fs"
moment = require "moment"
horoscope = require "horoscope"

artists = JSON.parse fs.readFileSync "artists_country.json","utf8"
signs = {}


artists.forEach (artist)->
#  console.log artist.name, artist.dob, calculateSign(artist.dob)
  sign = artist.sign
  signs[sign] ?= []
  signs[sign].push artist

for key, sign of signs
  console.log key, sign.length
