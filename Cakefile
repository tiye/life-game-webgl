
{print} = require "util"
{spawn} = require "child_process"

echo = (child) ->
  child.stderr.pipe process.stderr
  child.stdout.pipe process.stdout

d = __dirname
split = (str) -> str.split " "

queue = [
  "jade -O #{d}/page/ -wP #{d}/src/index.jade"
  "coffee -o #{d}/page/ -wbc #{d}/src/handle.coffee"
  "stylus -o #{d}/page/ -w #{d}/src/page.styl"
  "doodle #{d}/page/"
]

task "dev", "watch and convert files", ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..])