# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require event_emitter
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require backbone.marionette
#= require_tree .
#= require websocket_rails/main

window.Applications =
  SIMULATOR: 'SIMULATOR'
  LIVE_DISPLAY: 'LIVE_DISPLAY'

class WebsocketRailsAdapter
  constructor: (@_dispatcher) ->

  emit: (eventName, data) ->
    @_dispatcher.trigger event_name, data

  on: (eventName, callback) ->
    @_dispatcher.bind eventName, callback

# Ideas for some events to listen
# The value of a key in the object would be a function whose return value
# would be used as context for the event.
#
# DEFAULT_EVENTS:
#   hovered_over_payment_form: null
#   checked_out_contact_us: null
#   made_a_search_on_the_page: null

class Simulator
  constructor: (@_socket) ->

  start: ->
    console.log "Simulator#start"

class MetricsRecorder
  constructor: (@_socket) ->

  record: (eventName, context) ->
    @_socket.emit eventName, context


window.startApp = (appName) ->
  window.appToRun = appName

chooseApplicationToRun =  (socket) ->
  console.log "chooseApplicationToRun"
  switch window.appToRun
    when Applications.SIMULATOR
      window.App = new Simulator socket
      App.start()
    when Applications.LIVE_DISPLAY
      console.log "Starting #{appName}"
    else
      console.log "Unknown appliction #{window.appName}"

$ ->
  console.log "Document ready"
  window.dispatcher = new WebSocketRails 'localhost:3000/websocket'
  console.log "got dispatcher", dispatcher
  dispatcher.on_open = ->
    console.log "Websocket connection ready"
    chooseApplicationToRun(new WebsocketRailsAdapter dispatcher)

  dispatcher.on_close = ->
    console.log "Websocket got closed"

  dispatcher.on_error = ->
    console.error "Could not get websocket connection"

