window.LiveDisplay = (Mod, App, Backbone, Marionette, $, _) ->
  SOCKET_CHANNEL = 'dashboard'

  Mod.addInitializer ->
    @visitors = new OnlineVisitors []
    @visitors.fetch()

  Mod.on 'start', ->
    @listView = new VisitorsList collection: @visitors
    App.mainRegion.show @listView
    @socket = App.socket.joinChannel SOCKET_CHANNEL
    console.log "Socketo: ", @socket
    @socket.on 'new_rankings', @visitors.applyNewRankings

  class Visitor extends Backbone.Model
    initialize: ->
      @url = "/visitors/#{@id}.json"

  class OnlineVisitors extends Backbone.Collection
    url: '/visitors.json'
    model: Visitor

    comparator: (model, another) ->
      model.get 'rank' > another.get 'rank'

    # TODO: Later use visual effect similar to
    # http://stackoverflow.com/questions/1851475/using-jquery-how-to-i-animate-adding-a-new-list-item-to-a-list
    applyNewRankings: (rankings) =>
      console.log "Applying new rankings", rankings
      _.each rankings, (id, rank) =>
        model = @findWhere {id: id}
        @remove model
        console.log "Setting ranking from #{model.get('rank')} to #{rank}"
        model.set 'rank', rank
        @add model

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

    initialize: ->
      @collection.on 'change', @render

    appendHtml: (collectionView, itemView, index) ->
      console.log "appending "
      if collectionView.isBuffering
        collectionView._bufferedChildren.push(itemView)

      childrenContainer = if collectionView.isBuffering then $(collectionView.elBuffer) else this.getItemViewContainer(collectionView)
      children = childrenContainer.children()
      if (children.size() <= index)
        childrenContainer.append(itemView.el)
      else
        children.eq(index).before(itemView.el)
