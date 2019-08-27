require "cadmium_stemmer"

module Cadmium::Glove
  class Parser
    @text : String

    @stem : Bool

    @alphabetic : Bool

    @min_length : Int32

    @max_length : Int32

    @normalize : Bool

    @stop_words : Array(String)

    getter tokens : Array(String)

    def initialize(
      @text : String,
      *,
      @stem = true,
      @alphabetic = true,
      @normalize = true,
      @stop_words = [] of String,
      @min_length = 3,
      @max_length = 25
    )
      @tokens = [] of String
    end

    def tokenize
      text   = downcase(@text)
      text   = alphabetic(text) if @alphabetic
      tokens = split(text)
      tokens = stop_words(tokens) unless @stop_words.empty?
      tokens = normalize(tokens) if @normalize
      tokens = stem(tokens) if @stem
      tokens
    end

    def downcase(text)
      text.downcase
    end

    def split(text)
      text.split
    end

    def alphabetic(text)
      text.gsub(/([^\p{L}]+)|((?=\w*[a-z])(?=\w*[0-9])\w+)/, " ")
    end

    def stem(tokens)
      tokens.map { |token| Cadmium::PorterStemmer.stem(token) }
    end

    def normalize(tokens)
      tokens.select! do |word|
        word.size >= @min_length && word.size <= @max_length
      end
    end

    def stop_words(tokens)
      tokens.reject! do |word|
        @stop_words.includes?(word)
      end
    end
  end
end
