path = require "path"
module.exports =
  entry : "./src/index.coffee"
  output:
    filename: "./www/lib/bundle.js"
  module:
      rules: [
        {
          test: /\.coffee$/,
          use: [ 'coffee-loader' ]
        }
      ]
  resolve:
    extensions: ['.js', '.json', '.coffee']


  watch: true
  watchOptions : {}
