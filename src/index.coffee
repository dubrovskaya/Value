# $ = require "jquery"
#
# window.reload = Date.now()

prevData = null
# hotreload = ->
#   tryAgain = -> setTimeout (-> hotreload()),1000
#   jq = $.get
#     url: "lib/bundle.js"
#     dataType : "text"
#     success: (data)->
#       if prevData is null or prevData is data
#         prevData = data
#         tryAgain()
#       else
#         location.reload()
#   jq.fail -> tryAgain()
#
# hotreload()

url = "lib/bundle.js";
fetch(url)
  .then (response)->
      console.log "respon",response
      # response.text()
  .then (html) ->
      console.log "--",html


console.log "hello world from maria33a"
