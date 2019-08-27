require "../../spec_helper"

# Some overloading of private methods
class Cadmium::Glove::Workers::CooccurrenceWorker
  def caller
    @caller
  end
end

Spectator.describe Glove::Workers::CooccurrenceWorker do
  let(index) { {"quick" => 0, "brown" => 1, "fox" => 2} }
  let(pairs) do
    index.map { |w, i| Glove::TokenPair.new(w) }
  end
  let(threads) { 0 }
  let(caller) do
    model = Glove::Model.new(threads: threads)
    model.token_index = index
    model.token_pairs = pairs
    model
  end
  let(worker) { described_class.new(caller) }

  describe ".new" do
    it "keeps a reference to the caller class" do
      expect(worker.caller).to eq caller
    end

    it "dupes token_index off the caller" do
      expect(worker.token_index).to eq(index)
    end

    it "dupes token_pairs off the caller" do
      expect(worker.token_pairs).to eq(pairs)
    end
  end

  describe "#threads" do
    it "delegates method to the @caller" do
      expect(worker.threads).to eq(threads)
    end
  end

  describe "#run" do
    it "converts the vector results into a matrix" do
      response = worker.run
      expect(response).to be_a Apatite::Matrix(Float64)
    end
  end

  describe "#build_cooc_matrix_col" do
    it "builds the vector co-occurrence representation of a given token" do
      pairs[0].neighbors << "fox"
      result = worker.build_cooc_matrix_col(["fox", 2])

      expect(result.size).to eq(index.size)
      expect(result[0]).to eq(1)
    end
  end
end
