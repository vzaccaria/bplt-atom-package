{CompositeDisposable} = require 'atom'
Subscriber = require('emissary').Subscriber
_ = require('lodash')
promise = require('bluebird')
uid = require('uid')
os = require('os')
shelljs = require('shelljs')

debug = require('debug')
debug.enable("sk:*")
debug.log = console.log.bind(console)
debug = debug("{{name}}:index")

language = "source.gfm"

{ execStdIn, registerOnSave } = require('./utils')
{ parseWithCmdThroughStdin, registerCommand } = require('./utils')

cmd = "your command"
doIt = parseWithCmdThroughStdin(cmd, language)

plugin = module.exports

plugin.config =

    # Only if you want it to process after save && language enabled.
    onSave:    { type: 'boolean', default: true, description: "Format on save" }

plugin.name = "{{name}}"

plugin.activate = (state) ->


  debug("Activating")

  # Remember to add an entry to keymap.cson for each command
  registerCommand("toggle", (=> @toggle()), plugin)

  # Only if you want it to process after save && language enabled.
  registerOnSave(doIt, plugin)

plugin.deactivate = ->

plugin.toggle = ->
  doIt(atom.workspace.activePaneItem)
