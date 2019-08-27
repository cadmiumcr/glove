require "../spec_helper"

Spectator.describe Glove::Model do
  let(text) { "the quick brown fox jumped over the lazy dog" }
  let(model) { Glove::Model.new }

  describe ".new(options)" do
    it "sets options as instance variables" do
      expect(model.threads).to eq 4
    end

    it "sets cooc_matrix, word_vec, and word_biases" do
      expect(model.cooc_matrix).to be_empty
      expect(model.word_vec).to be_empty
      expect(model.word_biases).to be_empty
    end
  end

  describe "#fit" do
    # TODO: Add expectations here once Spectator supports `allow` and `receive`
  end

  describe "#train" do
    # let(cooc_matrix) { Apatite::Matrix.build(4, 4) { rand(0.0...1.0) } }
  end
end
