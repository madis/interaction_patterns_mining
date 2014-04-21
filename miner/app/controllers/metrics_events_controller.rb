class MetricsEventsController < WebsocketRails::BaseController
  def create
    p "Wadiis #{params}"
    WebsocketRails[:data_updated].trigger 'new', latest_post
  end
end
