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
    good_sequences = [
      %w(visit_payment_form select_phone_number visit_payment_form scroll read_contact_information),
      %w(select_phone_number click_link click_link visit_payment_form visit_payment_form),
      %w(select_phone_number scroll click_link visit_payment_form visit_payment_form),
      %w(visit_payment_form read_contact_information select_phone_number)
    ].each { |s|
      puts "Training good with #{s}"
      @ranking.train_good(s)
    }

    bad_sequences = [
      %w(random_stuff scroll random_stuff do_nothing_for_a_while),
      %w(scroll click_link random_stuff),
      %w(click_link click_link do_nothing_for_a_while),
      %w(random_stuff scroll do_nothing_for_a_while)
    ].each { |s|
      puts "Training bad with #{s}"
      @ranking.train_bad(s)
    }
  end
end
