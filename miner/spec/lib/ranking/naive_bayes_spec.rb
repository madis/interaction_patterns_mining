require 'ranking/naive_bayes'

describe Ranking::NaiveBayes do
  let(:good_words_training) { %w(hello nice super good) }
  let(:bad_words_training) { %w(evil bad dark bad) }
  let(:good_data) { %w(nice fabulous super) }
  let(:bad_data) { %w(evil britney visual_basic) }

  let(:subject) { described_class.new }

  before do
    subject.train_good(good_data)
    subject.train_bad(bad_data)
  end

  it 'finds clusters' do
    expect(subject.score(good_data)).to be > subject.score(bad_data)
  end

end
