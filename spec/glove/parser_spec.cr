require "../spec_helper"

Spectator.describe Glove::Parser do
  let(text) { "the quick brown Fx jumps over the lazy d0g" }
  let(parser) { Glove::Parser.new(text, stop_words: ["the"]) }
  let(tokens) { text.split }
  let(parsed) { %w(quick brown jump over lazi) }

  describe "#tokenize" do
    it "tokenizes the text string" do
      expect(parser.tokenize).to eq parsed
    end
  end

  describe "#downcase" do
    it "downcases all the letters" do
      expect(parser.downcase(text)).to eq text.downcase
    end
  end

  describe "#split" do
    it "splits the text string into an array" do
      expect(parser.split(text)).to be_a Array(String)
    end
  end

  describe "#alphabetic" do
    it "leaves only words that do not contain any numbers" do
      expect(parser.alphabetic(text)).not_to contain("d0g")
    end
  end

  describe "#stem" do
    it "stems all words in the text array" do
      expect(parser.stem(tokens)).not_to contain("jumps")
      expect(parser.stem(tokens)).to contain("jump")
    end
  end

  describe "#normalize" do
    it "removes words whose length is not within specified boundary" do
      expect(parser.normalize(tokens)).not_to contain("Fx")
    end
  end

  describe "#stop_words" do
    it "filters all stop words from the text" do
      expect(parser.stop_words(tokens)).not_to contain("the")
    end
  end
end
