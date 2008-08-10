#!/usr/bin/env ruby

require 'irb'
require 'fileutils'
require 'tokyocabinet'
include TokyoCabinet

path = "casket.bdb"

# create the object
bdb = BDB::new

FileUtils.rm_f(path)

# open the database
if(!bdb.open(path, BDB::OWRITER | BDB::OCREAT))
  ecode = bdb.ecode
  STDERR.printf("open error: %s\n", bdb.errmsg(ecode))
end

# store records
if(!bdb.put("foo", "hop") ||
   !bdb.put("bar", "step") ||
   !bdb.put("baz", "jump"))
  ecode = bdb.ecode
  STDERR.printf("put error: %s\n", bdb.errmsg(ecode))
end

# retrieve records
value = bdb.get("foo")
if(value)
  printf("%s\n", value)
else
  ecode = bdb.ecode
  STDERR.printf("get error: %s\n", bdb.errmsg(ecode))
end

# traverse records
@cur = cur = BDBCUR::new(bdb)
cur.first
while(key = cur.key)
  value = cur.val
  if(value)
    printf("%s:%s\n", key, value)
  end
  cur.next
end

def cur
  @cur
end

def pair
  [@cur.key, @cur.val]
end

at_exit { FileUtils.rm_f(path) }

IRB.start

