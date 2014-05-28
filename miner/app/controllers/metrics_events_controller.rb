class MetricsEventsController < ApplicationController
  def create
    puts "Create new? #{params}"
    EventHubClient.register_event params
  end
end
