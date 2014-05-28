window.LiveDisplay = (Mod, App, Backbone, Marionette, $, _) ->

  Mod.addInitializer ->
    @visitors = new OnlineVisitors []
    @visitors.fetch()

  Mod.on 'start', ->
    @listView = new VisitorsList collection: @visitors
    App.mainRegion.show @listView

  class Visitor extends Backbone.Model
    initialize: ->
      @url = "/visitors/#{@id}.json"

  class OnlineVisitors extends Backbone.Collection
    url: '/visitors.json'
    model: Visitor

    onDestroy: (model) ->
      console.log "Removing model", model
      @remove model

  class VisitorRow extends Marionette.ItemView
    template: 'visitor_row'
    tagName: 'tr'

    events:
      'click button.delete': '_handleDelete'

    _handleDelete: ->
      @model.destroy()

  class VisitorsList extends Marionette.CompositeView
    template: 'visitors_list'
    className: 'visitors_list'
    itemViewContainer: '.visitor-rows'

    itemView: VisitorRow
