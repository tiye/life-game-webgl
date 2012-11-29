
{print} = require "util"
{spawn} = require "child_process"

echo = (child, callback) ->
  child.stderr.on "data", (data) -> process.stderr.write data.toString()
  child.stdout.on "data", (data) -> print data.toString()
  child.on "exit", (code) -> callback?() if code is 0

make = (str) -> str.split " "

queue = [
  "mkdir -p src"
  "mkdir -p page"
  "touch src/index.jade"
  "touch src/page.styl"
  "touch src/handle.coffee"
  "jade -O page/ -wP src/index.jade"
  "coffee -o page/ -wbc src/handle.coffee"
  "stylus -o page/ -w src/page.styl"
  "doodle page/"
]

split = (str) -> str.split " "

task "dev", "watch and convert files", (callback) ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..]), callback