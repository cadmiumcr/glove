require "../spec_helper"

Spectator.describe Glove::Parser do
  let(text) { "the quick brown Fx jumps over the lazy d0g" }
  let(parser) { Glove::Parser.new(text, stop_words: ["the"]) }

  describe "#tokenize" do
    let(tokens) { %w(quick brown jumps over lazy) }

    it "tokenizes the text string" do
      expect(parser.tokenize).to eq tokens
    end
  end

  describe "#downcase" do
    it "downcases all the letters" do
      expect(parser.downcase).to eq text.downcase
    end
  end

  describe "#split" do
    it "splits the text string into an array" do
      expect(parser.split).to be_a Array(String)
    end
  end

  describe "#alphabetic" do
    it "leaves only words that do not contain any numbers" do
      expect(parser.alphabetic).not_to contain("d0g")
    end
  end

  describe "#stem" do
    pending "stems all words in the text array" do
      expect(parser.stem).not_to contain("jumps")
      expect(parser.stem).to contain("jump")
    end
  end

  describe "#normalize" do
    it "removes words whose length is not within specified boundary" do
      parser.split
      expect(parser.normalize).not_to contain("Fx")
    end
  end

  describe "#stop_words" do
    it "filters all stop words from the text" do
      expect(parser.stop_words).not_to contain("the")
    end
  end
end
