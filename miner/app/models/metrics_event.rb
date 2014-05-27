class MetricsEvent < ActiveRecord::Base
  belongs_to :originator, polymorphic: true
  validates_presence_of :originator
end
