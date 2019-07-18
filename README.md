# Cadmium::Glove

Pure Crystal implementation of Global Vectors for Word Representations.

> Note that this does not work quite right yet. Something is off with the math and it's returning incorrect results.

# Overview

GloVe is an unsupervised learning algorithm for obtaining vector representations for words. Training is performed on aggregated global word-word co-occurrence statistics from a corpus, and the resulting representations showcase interesting linear substructures of the word vector space.

# Resources

- [Documentation](http://www.rubydoc.info/github/vesselinv/glove)
- [Academic Paper on Global Vectors](http://nlp.stanford.edu/projects/glove/glove.pdf)
- [Original C Implementation](http://nlp.stanford.edu/projects/glove/)

#### Implementations in other languages

- [ruby](https://github.com/vesselinv/glove)
- [python](https://github.com/maciejkula/glove-python)
- [scala](https://github.com/petro-rudenko/spark-glove)


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     cadmium:
       github: watzon/cadmium
     cadmium_glove:
       github: watzon/cadmium_glove
   ```

2. Run `shards install`

## Usage

```crystal
require "cadmium"
require "cadmium_glove"

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
corpus = Glove::Corpus.build(text)
model.fit(corpus)

# Train the model
model.train

# Save the model as JSON
model.save("./data")
```

To import and use a model:

```crystal
# Load the previously saved model from the data directory
model = Glove::Model.load("./data")

# Get the most similar words
puts model.most_similar("quantum")
# => [["physics", 0.9974459436353388], ["mechanics", 0.9971606266531394], ["theory", 0.9965966776283189]]

# Find words that are releated to atom like quantum is related to physics
puts model.analogy_words("atom", "quantum", "physics")
# => [["electron", 0.9858380292886947], ["energie", 0.9815122410243475], ["photon", 0.9665073849076669]]
```

## Performance

TODO: Benchmarks

## Contributing

1. Fork it (<https://github.com/watzon/cadmium_glove/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
