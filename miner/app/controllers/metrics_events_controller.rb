class MetricsEventsController < ApplicationController
  def create
    puts "Create new? #{params}"
    # WebsocketRails[:data_updated].trigger 'new'
  end
end
