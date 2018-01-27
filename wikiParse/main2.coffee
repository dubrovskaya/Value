
request = require "request"
fs = require "fs"
moment = require "moment"
horoscope = require "horoscope"
sqlite3 = require('sqlite3')
db = new sqlite3.Database('./db/artists.db')


isNumeric = (n) ->
  return !isNaN(parseFloat(n)) && isFinite(n)


calculateSign = (dob) ->
  month = moment(dob).format("M")*1
  day = moment(dob).format("D")*1
  if isNumeric(month) and isNumeric(day)
    return horoscope.getSign(month:month, day:day)
  else return "n/a"

inbetween = (str, before, after) ->

  unless typeof str is "string"
    return null

  if before is 0
    position_start = 0
  else
    position_start = str.indexOf(before)
  substring = str.substr(position_start+before.length)

  if after
    position_end = substring.indexOf(after)
  else
    position_end = substring.length
  return substring.substr(0, position_end)




scrape_list = (url, callback) ->
  request url, (err, response, body) ->

    if err
      console.log "ERROR: can't fetch #{url}"
      callback []
    else
      list_array = body.split("<li><a href=\"/wiki")
      results = []
      for value, key in list_array
        value = inbetween value,0,"</li>"
        if typeof value is "string"
          wiki = "https://en.wikipedia.org/wiki"
          url  = wiki+value.substr(0, value.indexOf("\""))
          name = inbetween(value, "title=\"", "\"")
  #type = gettype(value)
          if url isnt wiki and name.indexOf('bands') < 0
            results.push {url: url, name: name}
        else
          console.log "not a string, shit.",value
      callback results
    #name = inbetween(body, """<span class="fn">""", """</span>""")


fetch_artist_info = (url, callback) ->
  request url, (err, response, body) ->
      dob = inbetween(body, """<span class="bday">""", """</span>""")
      name =  inbetween(body, """<span class="fn">""", """</span>""")
      sign = calculateSign(dob)
      callback {dob:dob, name:name, sign:sign}
  #  country = getcountry body



scrape_list "https://en.wikipedia.org/wiki/Lists_of_musicians", (resultsMaster) ->
  #console.log results

  resultsMaster.forEach (value, index) ->

    genre = value.name.slice(8)

    scrape_list value.url, (results) ->
      # console.log "scraping genre: #{genre}, there are #{results.length} musicians here..."
      i=0
      resultsInsert = ""
      results.forEach (value, index) ->
          i++
          fetch_artist_info value.url, (info) ->
            # console.log results.length,value.name, value.url
            if info.name and info.dob and info.name.length < 100 and info.dob.length < 100
              resultsInsert += "INSERT INTO artists VALUES ('#{info.name}', '#{info.dob}', '#{info.sign}','#{genre}','#{value.url}');\n"

              console.log "INSERT INTO artists VALUES ('#{info.name}', '#{info.dob}', '#{info.sign}','#{genre}','#{value.url}');"

            # if i is results.length
            #   console.log "writing #{value.url}..."
            #   db.exec resultsInsert, (err)->
            #     if err
            #       console.log "ERROR writing #{value.url}"
