%w[
  abstract_view
  tokyocabinet_view
  encoding_layer
  default_key_codec
  default_value_codec
  heads_update_strategy
  versions_update_strategy
  pretty_finder_layer
].map do |view|
  require "strokedb/views/#{view}"
end
