require "cadmium"
require "apatite"

require "./glove/version"
require "./glove/parser"
require "./glove/token_pair"
require "./glove/corpus"
require "./glove/model"

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
text = File.read("spec/data/quantum-physics.txt")
model.fit(text)

File.write("cooc_matrix.json", model.cooc_matrix.to_json)

# # Train the model
# model.train

# # Save the model as JSON
# model.save("./data")

# # # Load the previously saved model from the data directory
# # model = Glove::Model.load("./data")

# # Get the most similar words
# puts model.most_similar("quantum")
# # => [["physics", 0.9974459436353388], ["mechanics", 0.9971606266531394], ["theory", 0.9965966776283189]]

# # Find words that are releated to atom like quantum is related to physics
# puts model.analogy_words("atom", "quantum", "physics")

# # List the vector distance between the word and all other words in the corpus
# pp model.vector_distance("quantum")
