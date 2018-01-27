request = require "request"
fs = require "fs"

inbetween = (str, before, after) ->

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

# gettype = (str) ->
#   if str.indexOf(")") < str.length-1
#
#     if str.indexOf(",") > 0
#       type = inbetween(str, "), ")
#     else
#       type = inbetween(str, ") ")
#   else
#     type = "n/a"
#   #
#   # if str.indexOf(">") > 0
#   #   type = inbetween(str, ", ")
#
#   return type

# getcountry= (body)->
#   start = """<span class="birthplace">"""
#   position_start = body.indexOf(start)+start.length
#   body2=body.substr(position_start)
#   position_end = body2.indexOf()

scrape_list = (url, callback) ->
  request url, (err, response, body) ->
    begin = """<span class="mw-editsection-bracket">]</span></span></h2>"""
    end = """<h2><span class="mw-headline" id="Notes">Notes</span>"""
    body = inbetween(body, begin, end)
    list_array = body.split("href=\"")
    results = []
    for value, key in list_array
      value = inbetween value,0,"</li>"
      if typeof value is "string"
        wiki = "https://en.wikipedia.org"
        url  = wiki+value.substr(0, value.indexOf("\""))
        name = inbetween(value, "title=\"", "\"")
#type = gettype(value)
        unless url is wiki
          results.push {url: url, name: name}
      else
        console.log "not a string, shit.",value
    callback results
    #name = inbetween(body, """<span class="fn">""", """</span>""")


fetch_artist_info = (url, callback) ->
  request url, (err, response, body) ->
      dob = inbetween(body, """<span class="bday">""", """</span>""")
      name =  inbetween(body, """<span class="fn">""", """</span>""")
      callback {dob:dob, name:name}
  #  country = getcountry body


scrape_list "https://en.wikipedia.org/wiki/List_of_contemporary_artists", (results) ->
  #console.log results
  artists = []
  i = 0
  results.forEach (value, index) ->

      fetch_artist_info value.url, (info) ->
        i++
        console.log i,results.length,value.name
        if info.name.length < 100 and info.dob.length < 100
    #      console.log info.name, info.dob
          artists.push
            dob: info.dob
            name: info.name
            # type: value.type

        if i is results.length
          fs.writeFileSync "./artists.json", JSON.stringify artists, null, 2






# start "https://en.wikipedia.org/wiki/List_of_contemporary_artists", (result)->
#   console.log result



#setInterval (->),9000


# website = """
# Marina Abramović (Serbian Cyrillic: Марина Абрамовић, pronounced [marǐːna abrǎːmoʋitɕ]; born November 30, 1946) is a Serbian performance artist.[1] Her work explores the relationship between performer and audience, the limits of the body, and the possibilities of the mind. Active for over four decades, Abramović has been described as the "grandmother of performance art." She pioneered a new notion of identity by bringing in the participation of observers, focusing on "confronting pain, blood, and physical limits of the body."[2]
#
# """
#
# #position = website.indexOf("[")
# # console.log website.substr(0, website.indexOf("["))
#
# separator=website.indexOf(" ")
# end_lastname=website.indexOf("ć")
# born = website.indexOf("born")+1
#
# first_name = website.substr(0, separator)
# last_name = website.substr(separator+1, end_lastname-separator)


# console.log first_name
# console.log last_name
# console.log inbetween(website, "born", ")")
