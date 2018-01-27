wiki      = require('wikijs').default
moment    = require "moment"
horoscope = require "horoscope"
fs        = require "fs"


jstr = (str) -> JSON.stringify str,null,2

isNumeric = (n) ->
  return !isNaN(parseFloat(n)) && isFinite(n)


calculateSign = (dob) ->
  month = moment(dob).format("M")*1
  day = moment(dob).format("D")*1
  if isNumeric(month) and isNumeric(day)
    return horoscope.getSign(month:month, day:day)
  else return "n/a"

  # .then((page) -> page.info('alterEgo'))
  # .then(console.log);

getLinks = (link="Marina_Abramović") ->

  path = "../data/lists/#{link}.json"

  if fs.existsSync path
    console.log "cached:"+link
    return JSON.parse fs.readFileSync path

  else  
    a = await wiki().page(link)
    # b = await a.info()
    c = await a.links() 
    # d = await a.summary()
    # console.log a
    # console.log b
    fs.writeFile path, jstr c, "utf8",->
      console.log "#{path} written to disk."
    return c
    # console.log c
    # return await b

parsePerson = (link) ->

  path = "../data/people/#{link}.json"

  if fs.existsSync path
    # console.log "cached:"+link
    return JSON.parse fs.readFileSync path

  else
    a = await wiki().page(link)
    b = await a.info()
    d = await a.summary()
    b.summary = d
    if b.birthDate?.date
      b.sign = calculateSign b.birthDate.date
    else
      b.sign = "n/a"

    fs.writeFile path, jstr b, "utf8",->
      console.log "#{path} written to disk."

    return b



run = ->
  list = await getLinks("List_of_contemporary_artists")
  people = {}
  for v,k in list
    # if k < 5
      link = v.replace(" ","_")
      try
        people[link] = await parsePerson(link)
      catch e 
        console.log e

  # console.log people
  fs.writeFile "../data/List_of_contemporary_artists.json",JSON.stringify(people,null,2),"utf8",->
    console.log "file written to disk."

run()