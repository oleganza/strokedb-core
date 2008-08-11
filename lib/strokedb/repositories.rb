require 'strokedb/repositories/helpers'
require 'strokedb/repositories/abstract_repository'
require 'strokedb/repositories/abstract_async_repository'
require 'strokedb/repositories/metadata_hash_layer'
require 'strokedb/repositories/iterators'
require 'strokedb/repositories/tokyocabinet_repository'

__END__

Repositories are organized as a flat set of modules.
Each module implements a part of AbstractRepository API.
We are using the fact, that Ruby modules are not actually mixins,
but stack in an inheritance chain (just like classes and super classes).

When we do

  include A
  include B

we can call "super" in B's method to fallback to A's implementation.
This allows us to write plugins for repositories easily.
The most exciting fact is that final repository structure is built lazily:
when your application configures it using ClassFactory.
Using this technique we can split the whole project into very focused modules 
and give application developers an opportunity to easily fine tune repository 
configuration for their apps.


