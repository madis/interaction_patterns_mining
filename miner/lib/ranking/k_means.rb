require 'ranking'
require 'ai4r'

module Ranking
  class KMeans

    def initialize(good_center:, bad_center:, labels: EVENTS)
      @good_center = good_center
      @bad_center = bad_center

      @labels = labels
      @clusterer = Ai4r::Clusterers::KMeans.new
      # @clusterer.centroid_indices = [0]
    end

    def train(document)
      word_counts_vector = document.map do |line_words|
        vector_from_line(line_words)
      end

      # word_counts_vector.unshift(good_center_vector)
      # word_counts_vector.unshift(bad_center_vector)
      data_set = Ai4r::Data::DataSet.new data_items: word_counts_vector, data_labels: @labels

      @clusterer.build(data_set, 1)
    end

    # Dividing 1 by the distance because the closer the point is to the center,
    # the bigger should it's score be
    # If we have distances 2 and 4 then the scores will become 1/2=0.5 and
    # 1/4=0.25, which makes 1st one better as 0.5 > 0.25
    #
    # When
    def score(words)
      1.0 / @clusterer.distance(@clusterer.centroids[0], vector_from_line(words))
    end

    private

    def vector_from_line(line_words)
      @labels.map { |event_name|
        count = line_words.select { |word|
          word == event_name
        }.count
      }
    end

    def good_center_vector
      vector_from_line(@bad_center)
    end

    def bad_center_vector
      vector_from_line(@good_center)
    end
  end
end
