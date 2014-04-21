class MetricsEvent < ActiveRecord::Base
  belongs_to :originator, polymorphic: true
end
