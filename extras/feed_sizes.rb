#!/usr/bin/env ruby

# load necessary modules
require 'pstore'

class Array
  def sum
    ret = 0
    each { |val| ret += val }
    ret
  end
end

FeedSize = Struct.new(:key, :size)

# feed cache path
PATH = ARGV[0] || ENV['HOME'] + '/.raggle/feed_cache.store'

sizes = []
store = PStore::new(PATH)
store.transaction { |s|
  s.roots.each { |root|
    size = FeedSize.new(root, 0)
    s[root].each { |item|
      %w{title url desc}.each { |key|
        size.size += item[key].length if item[key]
      }
    }
    sizes << size
  }
}

sum = sizes.collect { |s| s.size }.sum
sizes.sort! { |a, b| a.size <=> b.size }
sizes.each { |size|
  puts '%6d (%2.1f%%): %s' % [size.size, size.size * 100.0 / sum, size.key]
}
  
