{CompositeDisposable} = require 'atom'
Subscriber = require('emissary').Subscriber
_ = require('lodash')
promise = require('bluebird')
uid = require('uid')
os = require('os')
shelljs = require('shelljs')
debug = require('debug')('{{name}}:utils')


execStdIn = (cmd, stdin) ->
  dname = os.tmpdir()
  filename = "#{dname}/#{uid(8)}"
  stdin.to("#{filename}.in")
  debug stdin
  command = "< #{filename}.in #{cmd} > #{filename}.out"
  debug command
  return new promise (resolve, reject) ->
    shelljs.exec command, (code, output) ->
      if code == 0
        content = shelljs.cat("#{filename}.out")
        shelljs.rm("-f", "#{filename}.in")
        shelljs.rm("-f", "#{filename}.out")
        resolve(content)
      else
        console.error(output)
        reject(code)

parseWithCmdThroughStdin = (cmd, language) ->
  return (editor) ->
    if editor.getGrammar()?.scopeName is language
      execStdIn(cmd, editor.getText()).then (newText) ->
        editor.setText(newText)

registerOnSave = (doIt, plugin) ->

  debug("Registering plugin")

  onSave = () ->
    if atom.config.get("#{plugin.name}.onSave")
      doIt(atom.workspace.activePaneItem)

  Subscriber.extend(plugin)

  atom.workspace.eachEditor (editor) ->
    buffer = editor.getBuffer()
    buffer.onWillSave onSave

registerCommand = (name, doIt, plugin) ->
  atom.commands.add('atom-workspace', "#{plugin.name}:#{name}", doIt)



module.exports = {
  execStdIn: execStdIn
  registerOnSave: registerOnSave
  registerCommand: registerCommand
  parseWithCmdThroughStdin: parseWithCmdThroughStdin
}
