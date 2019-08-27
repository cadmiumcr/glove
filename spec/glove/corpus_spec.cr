require "../spec_helper"

Spectator.describe Glove::Corpus do
  let(text) { "the quick brown fox jumped over the lazy dog" }
  let(opt) { {window: 3, min_count: 2, stop_words: [] of String} }
  let(corpus) { Glove::Corpus.new(text, **opt) }

  describe ".build" do
    it "forwards args to #initialize and calls #build_tokens on the instance" do
      corpus = described_class.build(text)
      expect(corpus).to be_a Glove::Corpus
      expect(corpus.tokens).not_to be_empty
    end
  end

  describe ".new" do
    it "gets parsed tokens from Parser class" do
      expect(corpus.tokens).to be_a Array(String)
    end

    it "sets options as instance variables" do
      expect(corpus.window).to eq opt[:window]
      expect(corpus.min_count).to eq opt[:min_count]
    end
  end

  describe ".build_tokens" do
    it "calls #build_count, #build_index, and #build_pairs and returns self" do
      expect(corpus.count).not_to be_empty
      expect(corpus.index).not_to be_empty
      expect(corpus.pairs).not_to be_empty
    end
  end

  describe "#count" do
    it "constructs a token count hash" do
      expect(corpus.count).to eq({"the" => 2})
    end
  end

  describe "#index" do
    it "constructs a token index hash" do
      expect(corpus.index).to eq({"the" => 0})
    end
  end

  describe "#pairs" do
    it "constructs array of token pairs with neighbors based on window option" do
      first_pair = corpus.pairs.first
      last_pair = corpus.pairs.last

      expect(first_pair.neighbors).to eq %w(quick brown fox)
      expect(last_pair.neighbors).to eq %w(fox jumped over lazy dog)
    end
  end

  describe "#token_neighbors(word, index)" do
    let(:corpus) { described_class.build(text, stop_words: [] of String, min_count: 1) }

    it "returns window number of neighbors on each side" do
      neighbors = corpus.token_neighbors("jumped", 4)
      expect(neighbors).to eq %w(brown fox over the)
    end
  end
end
