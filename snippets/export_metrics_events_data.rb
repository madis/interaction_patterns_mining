#!/usr/bin/env ruby

require 'bundler'

Bundler.setup

require 'awesome_print'
require 'salemove/domain'

DB_CONNECTION_SETTINGS = {
  adapter: 'postgresql',
  encoding: 'unicode',
  host: 'localhost',
  database: 'salemove_big',
  username: ENV['DBUSER'],
  password: ENV['DBPASS'],
  pool: 10,
  timeout: 5000
}

connections = ActiveRecord::Base.establish_connection(DB_CONNECTION_SETTINGS)

include Salemove::Models
DATASET_SIZE_LIMIT = 10

def events_without_engagement(limit=DATASET_SIZE_LIMIT)
  Visit.order('RANDOM()').limit(limit)
end

def events_with_engagement(limit=DATASET_SIZE_LIMIT)
  collected_data = []
  visits = Visitor.find(383380).visits # Engagement.where(initiator: 'visitor').where('start_time > ?', 1.months.ago).limit(limit).map(&:visit)
  visits.each do |v|
    puts "Metrics events: #{v.created_at..(v.created_at + 45.minutes)}"
    # v.visitor.metrics_events.map(&:name).where(created_at: v.created_at..(v.created_at + 45.minutes)).map(&:name)
    events = []
    puts "Going over all metrics events #{v.visitor.metrics_events.count}"
    v.visitor.metrics_events.each do |me|
      if (me.created_at > v.created_at) && me.created_at < (v.created_at + 45.minutes)
        # puts "Putting in name: #{me.name}"
        events << me.name
      else
        # puts "Not puting in #{me.name} #{v.created_at} < #{me.created_at} < #{v.created_at + 45.minutes}"
      end
    end
    collected_data << events
  end
  collected_data
end

def query_visitor_initiated_engagement_resulting_events(limit)
  visitor_initiated_engagement_event_counts = <<-SQL
  SELECT metrics_events.name, COUNT(*) AS cnt, visitors.id AS visitor_id, visits.id AS visit_id
  FROM metrics_events
  LEFT JOIN visitors ON visitors.id = metrics_events.originator_id
  LEFT JOIN engagements ON engagements.visitor_id = visitors.id AND engagements.initiator = 'visitor'
  LEFT JOIN visits ON visits.id = engagements.visit_id
  WHERE metrics_events.originator_type = 'Salemove::Models::Visitor'
    AND metrics_events.created_at > date '2014-04-10'
    AND engagements.created_at > date '2014-04-10'
    AND visits.created_at > date '2014-04-10'
  GROUP BY metrics_events.name, visitors.id, visits.id
  ORDER BY visits.id
  LIMIT #{limit};
  SQL
  ActiveRecord::Base.connection.execute(visitor_initiated_engagement_event_counts)
end

def query_visitor_initiated_non_engagement_resulting_events(limit)
  visitor_initiated_engagement_event_counts = <<-SQL
  SELECT
    me.name,
    COUNT(*) AS cnt,
    visitors.id AS visitor_id,
    v.id AS visit_id
  FROM metrics_events me
  INNER JOIN visitors ON visitors.id = me.originator_id
  INNER JOIN visits v ON v.visitor_id = visitors.id
                AND v.created_at BETWEEN me.created_at - interval '30 minutes' and me.created_at + interval '30 minutes'
                AND NOT EXISTS (
                      SELECT 1
                       FROM engagements
                      WHERE engagements.visit_id = v.id
                    )
  WHERE me.originator_type = 'Salemove::Models::Visitor'
    AND me.created_at > date '2014-04-10'
    AND v.created_at > date '2014-04-10'
  GROUP BY me.name, visitors.id, v.id
  ORDER BY v.id
  LIMIT #{limit};
  SQL
  ActiveRecord::Base.connection.execute(visitor_initiated_engagement_event_counts)
end

EventOccurance = Struct.new(:name, :times, :visit_id)

def engagement_events(limit)
  events = query_visitor_initiated_engagement_resulting_events(limit)
  grouped = group_occurances(events)
  unpacked = make_unpacked_event_name_array(grouped)
end

def non_engagement_events(limit)
  events = query_visitor_initiated_non_engagement_resulting_events(limit)
  grouped = group_occurances(events)
  unpacked = make_unpacked_event_name_array(grouped)
end

# [{"name"=>"open_reactive_countdown", "cnt"=>"3", "visitor_id"=>"2432710", "visit_id"=>"4673637"}]
def group_occurances(db_result_sequences)
  result_hash = {}
  db_result_sequences.each do |row|
    group_name = row['visit_id']
    result_hash[group_name] = [] unless result_hash.key?(group_name)
    result_hash[group_name] << EventOccurance.new(row['name'], row['cnt'].to_i, row['visit_id'].to_i)
  end
  result_hash
end

def make_unpacked_event_name_array(occurances)
  occurances.values.map { |v| v.inject([]) { |sum, e| puts "sum=#{sum} e=#{e}"; sum += [e.name]*e.times } }
end

def write_sequences_to_file(sequences, file_name)
  File.open(file_name, 'w') do |f|
    sequences.each_with_index do |e,i|
      f << "#{i}, #{e.join(',')}\n"
    end
  end
end

# 1. Get
write_sequences_to_file(engagement_events(10_000), 'engagement_events.csv'); 0
write_sequences_to_file(non_engagement_events(10_000), 'non_engagement_events.csv'); 0
