#!/usr/bin/env ruby

# 
# Copyright (C) 2003 Richard Lowe (richlowe) <richlowe@richlowe.net>
# 
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# 

##
# Dumps command lines to re-add feeds found in the feed cache.
# *really* handy when your FeedList gets eaten (which I tend to do to myself
# quite a lot).
#
# * Load the feed cache.
# * Iterate over it fetching the URL, and pulling out the title
# * print out command lines (using the default refresh) to re-add the feeds
#   found.

# load necessary modules
require 'pstore'
require 'net/http'
require 'rexml/document'

begin
  require 'net/https'
rescue LoadError
  $HAVE_SSL = false
else
  $HAVE_SSL = true
end

##
# Ugh, copy/paste.  This is why I want this stuff in resuable modules ;)
# -- richlowe 2003-07-01
def get_url(url)
  port = 80
  use_ssl = false
  
  # work with a copy of the url
  url = url.dup

  # check for ssl
  if url =~ /^https:/
    raise 'HTTPS support requires OpenSSL-Ruby' unless $HAVE_SSL
    use_ssl = true
  end

  # strip 'http://' prefix from URL
  url.gsub!(%r!^\w+?://!, '') if url =~ %r!^\w+?://!

  # get host and path portions of url
  raise "Couldn't parse URL: \"#{url}\"" unless url =~ /^(.+?)\/(.*)$/
  host, path = $1, $2

  # check for port in URL
  if host =~ /:(\d+)$/
    port = $1.to_i
    host.gsub!(/:(\d+)$/, '')
  end

  # initialize http connection
  http = Net::HTTP.start(host, port)
  http.use_ssl = use_ssl if $HAVE_SSL
  raise "Couldn't connect to host \"#{host}:#{port}\"" unless http

  # get result
  resp, ret = nil, ''
  begin
    resp, ret = http.get('/' << path)
  rescue 
    resp = $!.response

    # handle redirects
    if resp.code =~ /3\d{2}/
      ret = get_url resp['Location']
    else
      raise "HTTP Error: #$!"
    end
  ensure
    # close HTTP connection
    # Note: if we don't specify this, then the connection is pooled
    # for the HTTP/1.1 spec (do we prefer that kind of behavior?
    # maybe I should make in an option)
    http.finish 
  end

  # return URL content
  ret
end

def get_title(content)
  begin
    doc = REXML::Document.new content
  rescue REXML::ParseException => err
    raise "Error parsing RSS feed"
  end

  if e = doc.root.elements['//channel/title']
    return e.text
  end
end


# feed cache path
PATH = ARGV[0] || ENV['HOME'] + '/.raggle/feed_cache.store'

sizes = []
store = PStore::new(PATH)
store.transaction { |s|
  s.roots.each { |item|
    begin
      title = get_title(get_url item)
    rescue => err
      $stderr.puts "#{item}: #{err.message}"
    else
      puts "raggle -a -t \"#{title}\" -u \"#{item}\" -r 120 #Default refresh"
    end
  }
}




  
