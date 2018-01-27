sqlite3 = require('sqlite3')
db = new sqlite3.Database('./db/artists.db')

db.exec "INSERT INTO artists VALUES ('maria', 'hello', 'impatient','little','princess :)')",(err,res)->
  console.log arguments


setInterval (->),1000
