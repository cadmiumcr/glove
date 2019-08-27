require "../../spec_helper"

class Cadmium::Glove::Model
  def matrix_nnz
    previous_def
  end
end

Spectator.describe Glove::Workers::TrainingWorker do
  let(text) { "quick fox brown fox" }
  let(opt) { {min_count: 1, stop_words: [] of String} }
  let(model) { Glove::Model.new(threads: 1).fit(text, **opt) }
  let(index) { model.matrix_nnz[0] }
  let(worker) { described_class.new(model, [index]) }

  describe ".new" do
    it "dupes the caller's word_vec attribute" do
      expect(worker.word_vec).to eq(model.word_vec)
    end

    it "dupes the caller's word_biases attribute" do
      expect(worker.word_biases).to eq(model.word_biases)
    end
  end

  describe "#run" do
    pending "returns array of word_vec and word_biases after running the transforms" do
      expect(worker.run).to eq({model.word_vec, model.word_biases})
    end
  end

  describe "#work" do
    let(loss) { 1 }
    let(word_a_norm) { 1 }
    let(word_b_norm) { 1 }

    pending "calculates loss and norm for each matrix index and applies the new values" do
      worker.work([index])

      response = worker.calc_weights(index[0], index[1])
      expect(response).to eq([loss, word_a_norm, word_b_norm])
    end
  end

  describe "#calc_weights" do
    it "performs the calculation and returns loss and norm" do
      loss, norm1, norm2 = worker.calc_weights(index[0], index[1])

      expect(loss).to  be_close(0.8263035169883944,  0.0000000001)
      expect(norm1).to be_close(2.35639367662992,    0.0000000001)
      expect(norm2).to be_close(3.2180498853746733,  0.0000000001)
    end
  end

  describe "#apply_weights" do
    it "applies weights on the word_vec matrix" do
      result = worker.apply_weights(index[0], index[1], 1, 1, 1)
      expect(worker.word_vec[0, 0]).not_to eq(model.word_vec[0, 0])
    end

    it "applied loss reduction on word_biases" do
      worker.apply_weights(index[0], index[1], 1, 1, 1)

      bias1 = worker.word_biases[index[0]]
      bias2 = worker.word_biases[index[1]]
      model_bias1 = model.word_biases[index[0]]
      model_bias2 = model.word_biases[index[1]]

      expect(bias1).not_to eq(model_bias1)
      expect(bias2).not_to eq(model_bias2)
    end
  end
end
