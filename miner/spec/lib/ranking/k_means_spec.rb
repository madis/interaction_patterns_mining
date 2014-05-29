require 'ranking/k_means'

describe Ranking::KMeans do
  let(:good_words_training) { %w(hello nice super good) }
  let(:bad_words_training) { %w(evil bad dark bad) }
  let(:good_data) { %w(nice fabulous super) }
  let(:bad_data) { %w(evil britney visual_basic) }

  let(:subject) { described_class.new(good_center: good_words_training, bad_center: bad_words_training, labels: (good_words_training+bad_words_training).uniq) }

  before do
    subject.train([good_words_training, good_words_training, bad_words_training])
  end

  it 'finds clusters' do
    expect(subject.score(good_data)).to be > subject.score(bad_data)
  end
end
