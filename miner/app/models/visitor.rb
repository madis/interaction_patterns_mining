class Visitor < ActiveRecord::Base
  has_many :metrics_events, as: :originator, dependent: :destroy

  def rank
    if metrics_events.count > 0
      EventHubClient.ranker.score(metrics_events.map(&:name))
    else
      0
    end
  end

  def as_json(options={})
    super.merge(rank: rank, metrics_events: metrics_events.map(&:name))
  end
end
