class VisitorsController < ApplicationController
  def index
    @visitors = Visitor.all
    respond_to do |format|
      format.html
      format.json { render json: @visitors }
    end
  end

  def destroy
    visitor = Visitor.find(params[:id])
    respond_to do |format|
      if visitor.present?
        visitor.destroy()
        format.json { head :ok }
      else
        format.json { head :not_found }
      end
    end
  end

  def new_simulation
    redirect_to visitor_simulate_path(Visitor.create!)
  end

  def show
    visitor = Visitor.find(params[:id])
    respond_to do |format|
      if visitor.present?
        format.json { render json: visitor}
      else
        format.json { head :not_found }
      end
    end
  end

  def simulate
    @visitor = Visitor.find(params[:visitor_id])
    cookies[:visitor_id] = @visitor.id
  end
end
