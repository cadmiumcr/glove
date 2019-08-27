require "json"

module Cadmium::Glove
  class Corpus
    include JSON::Serializable

    getter count : Hash(String, Int32)?

    getter index : Hash(String, Int32)?

    getter pairs : Array(TokenPair)?

    property tokens : Array(String)

    property window : Int32

    property min_count : Int32

    # Convenience method for creating an instance and building the
    # token count and pairs.
    def self.build(text, window = nil, min_count = nil, **parser_options)
      Corpus.new(text, window, min_count, **parser_options).build_tokens
    end

    # Create a new `Glove::Corpus`
    def initialize(text, window = nil, min_count = nil, **parser_options)
      @window = window || 2
      @min_count = min_count || 5
      @tokens = Parser.new(text, **parser_options).tokenize
    end

    # Builds the token count, token index, and token pairs
    def build_tokens
      count
      index
      pairs
      self
    end

    # Hash that stores the occurence count of unique tokens.
    def count
      @count ||= @tokens.reduce({} of String => Int32) do |hash, item|
        hash[item] ||= 0
        hash[item] += 1
        hash
      end.to_h.select { |word, count| count >= min_count }
    end

    # A hash whose values hold a sequential index of a word as it
    # appears in the `#count` hash.
    def index
      @index ||= count.keys.each_with_index.reduce({} of String => Int32) do |hash, (word, idx)|
        hash[word] =  idx
        hash
      end
    end

    # Iterates over the tokens and constructs `Glove::TokenPair`s where
    # neighbors hold the adjacent (context) words. The number of neighbors
    # is controlled by `#window` (on each side).
    def pairs
      @pairs ||= @tokens.map_with_index do |word, index|
        next unless count[word]? && count[word] >= @min_count

        TokenPair.new(word, token_neighbors(word, index))
      end.compact.reject { |p| p.neighbors.empty? }
    end

    # Construct an array of neighbors to the given word and its index in
    # the `#tokens` array.
    def token_neighbors(word, index)
      start_pos = index - window < 0 ? 0 : index - window
      end_pos   = (index + window >= tokens.size) ? tokens.size - 1 : index + window

      tokens[start_pos..end_pos].map do |neighbor|
        neighbor unless word == neighbor
      end.compact
    end
  end
end
