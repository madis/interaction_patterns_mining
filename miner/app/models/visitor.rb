class Visitor < ActiveRecord::Base
  has_many :metrics_events, as: :originator, dependent: :destroy

  def rank
    0
  end
end
