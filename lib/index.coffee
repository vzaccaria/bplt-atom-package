{CompositeDisposable} = require 'atom'
Subscriber = require('emissary').Subscriber
_ = require('lodash')

packageName = "{{name}}"
language = "source.haskell"

doIt = (editor) ->
  if editor.getGrammar()?.scopeName is language
    newText = """
    xyz
    #{editor.getText()}
    """
    editor.setText(newText)

onSave = () ->
  if atom.config.get("#{packageName}.onSave")
    doIt(atom.workspace.activePaneItem)

plugin = module.exports

Subscriber.extend(plugin)

plugin.config =
    onSave:
      type: 'boolean'
      default: true
      description: "Format on save"

plugin.activate = (state) ->
  atom.commands.add('atom-workspace', "#{packageName}:toggle", => @toggle())
  atom.workspace.eachEditor (editor) ->
      buffer = editor.getBuffer()
      plugin.unsubscribe(buffer)
      plugin.subscribe(buffer, 'saved', _.debounce(onSave, 50))

plugin.deactivate = ->

plugin.toggle = ->
  doIt(atom.workspace.activePaneItem)
