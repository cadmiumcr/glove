require "apatite"
require "parallel_worker"

module Cadmium::Glove
    module Workers
      class CooccurrenceWorker

        @caller : Cadmium::Glove::Model

        getter token_index : Hash(String, Int32)

        getter token_pairs : Array(TokenPair)

        delegate threads, to: @caller

        # Creates a new `CooccurrenceWorker` instance
        def initialize(calling_class : Model)
          @caller = calling_class
          @token_index = @caller.token_index.dup
          @token_pairs = @caller.token_pairs.dup
        end

        # Perform the building of the `Matrix`.
        def run
          results = token_index.to_a.map do |slice|
            build_cooc_matrix_col(slice)
          end

          Apatite::Matrix.columns(results)
        end

        # Creates a vector column for the cooc_matrix based on given token.
        # Calculates sum for how many times the word exists in the constext of the
        # entire vocabulary
        def build_cooc_matrix_col(slice)
          token = slice[0]
          vector = Array(Float64).new(token_index.size, 0)

          token_pairs.each do |pair|
            key = token_index[pair.token]
            sum = pair.neighbors.select { |word| word == token }.size
            vector[key] += sum
          end

          vector.to_a
        end
      end
    end
end
