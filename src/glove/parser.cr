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
      @stem = false,
      @alphabetic = true,
      @normalize = true,
      @stop_words = [] of String,
      @min_length = 3,
      @max_length = 25
    )
      @tokens = [] of String
    end

    def tokenize
      downcase
      alphabetic if @alphabetic
      split
      stop_words unless @stop_words.empty?
      normalize if @normalize
      stem if @stem
      tokens
    end

    def downcase
      @text = @text.downcase
    end

    def split
      @tokens = @text.split
    end

    def alphabetic
      @text = @text.gsub(/([^\p{L}]+)|((?=\w*[a-z])(?=\w*[0-9])\w+)/, " ")
    end

    def stem
      @tokens.map!(&.stem)
    end

    def normalize
      @tokens.select! do |word|
        word.size >= @min_length && word.size <= @max_length
      end
    end

    def stop_words
      @tokens.reject! do |word|
        @stop_words.includes?(word)
      end
    end
  end
end
