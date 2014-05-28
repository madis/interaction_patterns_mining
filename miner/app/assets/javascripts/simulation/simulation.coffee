window.Simulation = (Mod, App, Backbone, Marionette, $, _) ->
  SOCKET_CHANNEL = 'simulation'

  NUM_KEY_OFFSET = 47

  Mod.on 'start', ->
    (new EventNames).fetch success: (names) =>
      @eventModels = _.map names.attributes, (eventName, index) =>
        console.log "Mapping", eventName, index
        new MetricsEvent name: eventName, id: parseInt(index)+1, originator_type: 'Visitor', originator_id: $.cookie('visitor_id')
      console.log "Creating collection", @eventModels
      @eventCollection = new MetricsCollection @eventModels

      # Register global keyup listener for num-keys
      ($ document).on 'keyup', (event) =>
        if [1..9].indexOf(event.which - NUM_KEY_OFFSET) > 0
          @eventCollection.userPicked(event.which - (NUM_KEY_OFFSET+1))

        console.log "Got keyup", event.which
      console.log "Ze event models are", @eventCollection
      @socket = App.socket.joinChannel SOCKET_CHANNEL
      App.mainRegion.show new ButtonList collection: @eventCollection

  class window.EventNames extends Backbone.Model
    url: '/metrics_events/names'

  class MetricsEvent extends Backbone.Model
    url: '/metrics_events'

    occur: ->
      console.log "It occured: #{@get 'name'}"
      App.socket.emit 'metrics_event', @attributes
      @trigger 'happened'

  class MetricsCollection extends Backbone.Collection
    userPicked: (modelId) ->
      pickedModel = @get modelId
      if pickedModel?
        pickedModel.occur()

  class EventButton extends Marionette.ItemView
    template: 'event_button'

    events:
      click: '_onClick'

    initialize: ->
      @model.on 'happened', @_highlight

    onClose: ->

    _highlight: =>
      @$el.fadeTo(100, 0.5).fadeTo(100, 1)

    _onKeyup: (event) ->
      console.log "There was keyup", event.which
      @model.occur()

    _onClick: ->
      console.log "Clicked", @model
      @model.occur()

  class ButtonList extends Marionette.CollectionView
    itemView: EventButton

    onRender: ->
      console.log "Rendering collection", @
