class EventsController < WebsocketRails::BaseController
  def create
    puts "EventsController Got event #{message}"
    EventHubClient.register_event(message)
  end

  def client_connected
    puts "Client connected"
  end
end
