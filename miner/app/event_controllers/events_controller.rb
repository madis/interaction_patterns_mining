class EventsController < WebsocketRails::BaseController
  def create
    event = MetricsEvent.create(message.except(:id))
  end

end
