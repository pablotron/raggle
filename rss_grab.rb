#!/usr/bin/env ruby

#######################################################################
# rss_grab.rb - get contents of RSS feed                              #
# by Paul Duncan <pabs@pablotron.org>                                 #
#                                                                     #
#                                                                     #
# This file is distributed with Raggle, please see the Raggle page at #
# http://www.pablotron.org/software/raggle/ for the latest version of #
# this software.                                                      #
#                                                                     #
#                                                                     #
# Copyright (C) 2003 Paul Duncan, and various contributors.           #
#                                                                     #
# Permission is hereby granted, free of charge, to any person         #
# obtaining a copy of this software and associated documentation      #
# files (the "Software"), to deal in the Software without             #
# restriction, including without limitation the rights to use, copy,  #
# modify, merge, publish, distribute, sublicense, and/or sell copies  #
# of the Software, and to permit persons to whom the Software is      #
# furnished to do so, subject to the following conditions:            #
#                                                                     #
# The above copyright notice and this permission notice shall be      #
# included in all copies of the Software, its documentation and       #
# marketing & publicity materials, and acknowledgment shall be given  #
# in the documentation, materials and software packages that this     #
# Software was used.                                                  #
#                                                                     #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               #
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY    #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF          #
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION  #
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.     #
#######################################################################

# load necessary modules
require 'rexml/document'
require 'net/http'
begin 
  require 'net/https'
  $HAVE_SSL = true
rescue
  $HAVE_SSL = false
end

# FeedItem struct definition
FeedItem = Struct.new :title, :link, :desc

# check command-line options
unless ARGV.size > 0
  $stderr.puts "Usage: #$0 [feed_url]"
  exit -1
end

#
# Return the contents of a URL
#
def get_url(url)
  port = 80
  use_ssl = false

  if url =~ /^https:/
    raise 'HTTPS support requires OpenSSL-Ruby' unless $HAVE_SSL
    use_ssl = true
  end

  # strip 'http://' prefix from URL
  url.gsub!(/^\w+?:\/\//, '') if url =~ /^\w+?:\/\//

  # get host and path portions of url
  raise "Couldn't parse URL: \"#{url}\"" unless url =~ /^(.+?)\/(.+)$/
  host, path = $1, $2

  # check for port in url
  if host =~ /:(\d+)$/
    port = $1 
    host.gsub!(/:(\d+)$/, '')
  end

  # init http connection
  http = Net::HTTP.start(host, port)
  http.use_ssl = use_ssl if $HAVE_SSL
  raise "Couldn't connect to host \"#{host}:#{port}\"" unless http

  # get result
  ret = ''
  begin
    http.get('/' << path) { |line| ret << line }
  rescue 
    raise "HTTP Error: #$!"
  end

  # close HTTP connection
  # Note: if we don't specify this, then the connection is pooled for the
  # HTTP/1.1 spec (do we prefer that kind of behavior?  maybe I should make in
  # an option)
  http.finish

  # return URL content
  ret
end

# get URL specified on the command-line
url = ARGV.shift
begin
  content = get_url url
rescue
  raise "Couldn't get url \"#{url}\": #$!."
end

# parse URL content
doc = REXML::Document.new content

# build list of feed items
feed_items = []
doc.root.elements.each('//item') { |e| 
  feed_items << FeedItem.new(e.elements['title'].text,
                             e.elements['link'].text,
                             e.elements['description'].text)
}

# iterate through and print each feed item
feed_items.each { |item| puts item.title << ': ' << item.link }
