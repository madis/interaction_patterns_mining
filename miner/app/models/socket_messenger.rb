class SocketMessenger
  SIMULATION = :simulation
  DASHBOARD = :dashboard

  def self.send_rankings(rankings)
    WebsocketRails[DASHBOARD].trigger 'new_rankings', rankings
  end

  def self.send_new_visitor(visitor)
    WebsocketRails[DASHBOARD].trigger 'new_visitor', visitor.as_json
  end
end
