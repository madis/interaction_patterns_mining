class MetricsEventsController < ApplicationController
  def create
    puts "Create new? #{params}"
    EventHubClient.register_event params
  end

  def names
    render json: Ranking::EVENTS
  end
end
