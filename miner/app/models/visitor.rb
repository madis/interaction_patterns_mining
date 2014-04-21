class MetricsEvent < ActiveRecord::Base
    has_many :metrics_events, as: :originator, dependent: :destroy
end
