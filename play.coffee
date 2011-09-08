#!/usr/bin/env coffee
#
# This is the script that you can run at the command line to see how
# strategies play against each other.

{State,kingdoms} = require './gameState'
{BasicAI} = require './basicAI'
fs = require 'fs'
coffee = require 'coffee-script'

loadStrategy = (filename) ->
  ai = new BasicAI()
  console.log(filename)

  changes = coffee.eval(
    fs.readFileSync(filename, 'utf-8'),
    {sandbox: {}}
  )
  for key, value of changes
    ai[key] = value
  ai

playGame = (filenames) ->
  ais = (loadStrategy(filename) for filename in filenames)
  st = new State().initialize(ais, kingdoms.allDefined)
  until st.gameIsOver()
    st.doPlay()
  result = ([player.ai.toString(), player.getVP(st), player.turnsTaken] for player in st.players)
  console.log(result)
  result

this.playGame = playGame
args = process.argv[2...]
playGame(args)
