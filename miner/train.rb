require 'stuff-classifier'
require 'csv'

store = StuffClassifier::FileStorage.new("naive-bayes.dat")

# global setting
StuffClassifier::Base.storage = store

# or alternative local setting on instantiation, by means of an
# optional param ...
cls = StuffClassifier::Bayes.new("Visitor Rank", :purge_state => true, :storage => store)

CSV.foreach('../data/engagement_data/non_engagement_events.csv') do |row|
	cls.train(:not_interested, row[1..-1].join(' '))
end

CSV.foreach('../data/engagement_data/visitor_initiated_engagement_event_sequences.csv') do |row|
	cls.train(:interested, row[1..-1].join(' '))
end


# after training is done, to persist the data ...
cls.save_state
test1 = "click_close_reactive,show_reactive,show_reactive,show_reactive,show_reactive,show_reactive,show_reactive,show_reactive,show_reactive"
test2 = "click_close_reactive click_close_reactive click_reactive_countdown"
puts "==== test 1 ===="
puts "interested: #{cls.text_prob(test1, :interested)}"
puts "not_interested: #{cls.text_prob(test1, :not_interested)}"
puts "==== test 2 ===="
puts "interested: #{cls.text_prob(test2, :interested)}"
puts "not_interested: #{cls.text_prob(test2, :not_interested)}"