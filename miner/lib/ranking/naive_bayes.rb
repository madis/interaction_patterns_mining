require 'stuff-classifier'

module Ranking
  class NaiveBayes
    CLASSIFIER_NAME = 'good vs bad'
    GOOD_CATEGORY = :good
    BAD_CATEGORY = :bad

    def initialize
      @classifier = StuffClassifier::Bayes.new(CLASSIFIER_NAME)
    end

    def train_good(words)
      @classifier.train(GOOD_CATEGORY, words.join(' '))
    end

    def train_bad(words)
      @classifier.train(BAD_CATEGORY, words.join(' '))
    end

    def score(words)
      puts "With words: #{words}"
      @classifier.text_prob(words.join(' '), GOOD_CATEGORY)
    end

  end
end
