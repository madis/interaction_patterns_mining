class VisitorsController < ApplicationController
  def index
    @visitors = Visitor.all
  end

  def new_simulation
    redirect_to visitor_simulate_path(Visitor.create!)
  end

  def simulate
    @visitor = Visitor.find(params[:visitor_id])
    cookies[:visitor_id] = @visitor.id
  end
end
