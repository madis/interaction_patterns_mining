class EventHubClient


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
    send_new_rankings
  end

  def self.send_new_rankings
    puts "Sending new rankings"
    when_rankings_ready do |rankings|
      puts "Triggering to dashboard"
      SocketMessenger.send_rankings rankings
    end
  end

  def self.when_rankings_ready
    scores = Visitor.all.map { |v| {id: v.id, score: ranker.score(v.metrics_events.map(&:name))} }
    yield scores
  rescue Exception => e
    puts "Midagi on kannis #{e}"
  end

  def self.ranker
    if @ranking.blank?
      @ranking = Ranking::NaiveBayes.new
      train
    end

    @ranking
  end

  def self.train
    @ranking.train_good(%w(visit_payment_form read_contact_information select_phone_number))
    @ranking.train_bad(%w(random_stuff scroll do_nothing_for_a_while))
  end
end
