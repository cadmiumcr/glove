require "json"

module Cadmium::Glove
  record TokenPair, token : String = "", neighbors : Array(String) = [] of String do
    include JSON::Serializable

    def to_s(io)
      io << "TokenPair[token: #{@token}, neighbors: {#{@neighbors.join(", ")}}"
    end

    def pretty_print(pp)
      pp.text(to_s)
    end
  end
end
