window.Simulation = (Mod, App, Backbone, Marionette, $, _) ->
  SOCKET_CHANNEL = 'simulation'

  EVENTS = ['visit_payment_form', 'read_contact_information', 'click_link', 'make_a_search_on_the_page', 'select_phone_number', 'scroll']
  NUM_KEY_OFFSET = 47

  Mod.addInitializer ->
    console.log "Creating MetricsEvents"
    @eventModels = _.map EVENTS, (eventName, index) ->
      new MetricsEvent name: eventName, id: index+1, originator_type: 'Visitor', originator_id: $.cookie('visitor_id')
    @eventCollection = new MetricsCollection @eventModels

    # Register global keyup listener for num-keys
    ($ document).on 'keyup', (event) =>
      if [1..9].indexOf(event.which - NUM_KEY_OFFSET) > 0
        @eventCollection.userPicked(event.which - (NUM_KEY_OFFSET+1))

      console.log "Got keyup", event.which

  Mod.on 'start', ->
    console.log "Ze event models are", @eventCollection
    @socket = App.socket.joinChannel SOCKET_CHANNEL
    App.mainRegion.show new ButtonList collection: @eventCollection

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
