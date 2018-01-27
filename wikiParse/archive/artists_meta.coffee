fs = require "fs"
moment = require "moment"
horoscope = require "horoscope"

artists = JSON.parse fs.readFileSync "artists.json","utf8"
signs = {}
calculateAge = (dob) ->
    console.log moment().diff(dob, 'years')

calculateSign = (dob) ->
  month = moment(dob).format("M")*1
  day = moment(dob).format("D")*1
  return horoscope.getSign(month:month, day:day)


artists.forEach (artist)->
#  console.log artist.name, artist.dob, calculateSign(artist.dob)
  sign = calculateSign(artist.dob)
  signs[sign] ?= []
  artist.sign = sign
  signs[sign].push artist

for key, sign of signs
  console.log key, sign.length
