#= require event_emitter
#= require jquery
#= require jquery_ujs
#= require underscore
#= require backbone
#= require backbone.marionette
#= require jquery.cookie
#= require skim
#= require_tree ../templates
#= require_tree .
#= require websocket_rails/main

window.Applications =
  SIMULATOR: 'SIMULATOR'
  LIVE_DISPLAY: 'LIVE_DISPLAY'

class WebsocketRailsAdapter
  constructor: (@_dispatcher) ->

  joinChannel: (channelName) ->
    new WebsocketRailsAdapter @_dispatcher.subscribe channelName

  emit: (eventName, data) ->
    @_dispatcher.trigger eventName, data

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

Marionette.Renderer.render = (template, data) ->
  return unless template?

  if typeof template is "function"
    template(data)
  else
    JST[template](data)

chooseApplicationToRun =  (socket) ->
  window.App = new Marionette.Application
  App.socket = socket
  App.addRegions mainRegion: '#main-region'

  switch window.appToRun
    when Applications.SIMULATOR
      App.module 'Simulation', Simulation
      App.start(socket)
    when Applications.LIVE_DISPLAY
      console.log "Starting live display"
      App.module 'LiveDisplay', LiveDisplay
      App.start(socket)
    else
      console.log "Unknown appliction #{window.appToRun}"

$ ->
  console.log "Document ready"
  window.dispatcher = new WebSocketRails "#{window.location.host}/websocket"
  console.log "got dispatcher", dispatcher
  dispatcher.on_open = ->
    console.log "Websocket connection ready"
    chooseApplicationToRun(new WebsocketRailsAdapter dispatcher)

  dispatcher.on_close = ->
    console.log "Websocket got closed"

  dispatcher.on_error = ->
    console.error "Could not get websocket connection"

