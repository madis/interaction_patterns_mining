class Visitor < ActiveRecord::Base
  has_many :metrics_events, as: :originator, dependent: :destroy

  def rank
    0
  end

  def as_json(options={})
    super.merge(rank: rank, metrics_events: metrics_events.map(&:name))
  end
end
