require "parallel_worker"
require "cadmium"
require "apatite"

require "./glove/version"
require "./glove/parser"
require "./glove/token_pair"
require "./glove/corpus"
require "./glove/model"

module Cadmium::Glove

end

include Cadmium

# Create a new model. Values used here are the defaults.
model = Glove::Model.new(
  max_count: 100,
  learning_rate: 0.05,
  alpha: 0.75,
  num_components: 30,
  epochs: 5
)

# Feed the model some text
text = File.read("quantum-physics.txt")
model.fit(text)

# Alternatively you can pass the model a Corpus object
# corpus = Glove::Corpus.build("the quick brown fox jumped over the lazy dog", min_count: 1, stop_words: false)
# model.fit(corpus)

# Train the model
model.train

# Save the model as JSON
model.save("./data")

# # Load the previously saved model from the data directory
# model = Glove::Model.load("./data")

# # Get the most similar words
# puts model.most_similar("quantum")
# # => [["physics", 0.9974459436353388], ["mechanics", 0.9971606266531394], ["theory", 0.9965966776283189]]

# # Find words that are releated to atom like quantum is related to physics
# puts model.analogy_words("atom", "quantum", "physics")
# # => [["electron", 0.9858380292886947], ["energie", 0.9815122410243475], ["photon", 0.9665073849076669]]

pp model.vector_distance("quantum")
