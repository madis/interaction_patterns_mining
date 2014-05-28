class EventHubClient
  module Channels
    SIMULATION = :simulation
    DASHBOARD = :dashboard
  end

  def self.register_event(attributes)
    puts "Wut?"
    originator_id = attributes[:originator_id]
    originator_type = attributes[:originator_type]
    event_name = attributes[:name]
    puts "Registering #{attributes}"
    MetricsEvent.create(originator_id: originator_id, originator_type: originator_type, name: event_name)
  rescue Exception => e
    puts "Perse #{e}"
  ensure
    when_rankings_ready do |rankings|
      puts "Triggering to dashboard"
      WebsocketRails[Channels::DASHBOARD].trigger 'new_rankings', rankings
    end
  end

  def self.when_rankings_ready
    rankings = Visitor.all.map(&:id).shuffle
    puts "Calculating rankings #{rankings}"
    yield rankings
  end
end
