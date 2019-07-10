# Cadmium::Glove

Pure Crystal implementation of Global Vectors for Word Representations.

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
     cadmium_glove:
       github: watzon/cadmium_glove
   ```

2. Run `shards install`

## Usage

```crystal
require "cadmium_glove"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/watzon/cadmium_glove/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
