module Cadmium::Glove
  class Parser
    include Cadmium::Util::StopWords

    @text : String

    @stem : Bool

    @alphabetic : Bool

    @min_length : Int32

    @max_length : Int32

    @normalize : Bool

    @stop_words : Bool

    getter tokens : Array(String)

    def initialize(
      @text : String,
      *,
      @stem = false,
      @alphabetic = true,
      @normalize = true,
      @stop_words = true,
      @min_length = 3,
      @max_length = 25
    )
      @tokens = [] of String
    end

    def tokenize
      downcase
      alphabetic if @alphabetic
      split
      stop_words if @stop_words
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
      @text = @text.gsub(/([^[:alpha:]]+)|((?=\w*[a-z])(?=\w*[0-9])\w+)/, " ")
    end

    def stem
      @tokens.map!(&.stem)
    end

    def normalize
      @tokens.select! do |word|
        (@min_length..@max_length).includes?(word.size)
      end
    end

    def stop_words
      @tokens.reject! do |word|
        @@stop_words.includes?(word)
      end
    end
  end
end
