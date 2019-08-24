require "apatite"

module Cadmium::Glove
  module Workers
    class TrainingWorker
      @caller : Cadmium::Glove::Model

      getter indices : Array(Tuple(Int32, Int32))

      getter word_vec : Apatite::Matrix(Float64)

      getter word_biases : Array(Float64)

      delegate cooc_matrix, threads, max_count, alpha, learning_rate, to: @caller

      # Creates a new `TrainingWorker` instance
      def initialize(calling_class : Model, indices)
        @caller = calling_class
        @indices = indices
        @word_vec = @caller.word_vec.dup
        @word_biases = @caller.word_biases.dup
      end

      def run
        work(indices)
        {@word_vec, @word_biases}
      end

      def work(slice)
        slice.each do |slot|
          w1, w2 = slot
          loss, word_a_norm, word_b_norm = calc_weights(w1, w2)

          apply_weights(w1, w2, loss, word_a_norm, word_b_norm)
        end
      end

      def calc_weights(w1, w2, prediction = 0.0, word_a_norm = 0.0, word_b_norm = 0.0)
        count = cooc_matrix[w1, w2]

        word_vec.column_vectors.each do |col|
          w1_context = col[w1]
          w2_context = col[w2]

          prediction = prediction + w1_context + w2_context
          word_a_norm += w1_context * w1_context
          word_b_norm += w2_context * w2_context
        end

        prediction = prediction + word_biases[w1] + word_biases[w2]
        word_a_norm = Math.sqrt(word_a_norm)
        word_b_norm = Math.sqrt(word_b_norm)
        entry_weight = [1.0, (count / max_count)].min ** alpha
        loss = entry_weight * (prediction - Math.log(count))

        {loss, word_a_norm, word_b_norm}
      end

      def apply_weights(w1, w2, loss, word_a_norm, word_b_norm)
        col_vecs = word_vec.column_vectors.map do |col|
          col = col.to_a
          col[w1] = (col[w1] - learning_rate * loss * col[w2]) / word_a_norm
          col[w2] = (col[w2] - learning_rate * loss * col[w2]) / word_b_norm
          col
        end

        word_vec = Apatite::Matrix.columns(col_vecs)

        word_biases[w1] -= learning_rate * loss
        word_biases[w2] -= learning_rate * loss
      end
    end
  end
end
