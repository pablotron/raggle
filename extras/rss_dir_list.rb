#!/usr/bin/env ruby

########################################################################
# rss_dir_list.rb - test command for Raggle exec: URLs                 #
# by Paul Duncan <pabs@pablotron.org>                                  #
#                                                                      #
# Output an RSS feed describing the contents of a directory            #
#                                                                      #
# Note: This command can take quite a while large directories and/or   #
# slower machines.                                                     #
########################################################################

PATH = ARGV.shift || '.'

class String
  def html_escape
    str = dup
    str.gsub!(/&/, '&amp;') if str =~ /&/
    str.gsub!(/</, '&lt;') if str =~ /</
    str.gsub!(/>/, '&gt;') if str =~ />/
    str
  end
end

time_str = Time.now.to_s.html_escape
puts <<-ENDHEADER
<?xml version='1.0' encoding='iso-8859-1'?>

<rss version='0.91'>
  <channel>
    <title>Dir List: '#{File::basename(PATH)}'</title>
    <link>http://www.raggle.org/</link>
    <description>
      Output of the following command&lt;br&gt;
      (last ran at #{time_str}):

      &lt;pre&gt;
        #$0 #{PATH.html_escape}
      &lt;/pre&gt;
    </description>
  </channel>
ENDHEADER

Dir["#{PATH}/*"].each { |path|
  next if path =~ /^\./

  puts <<-ENDFILEHEADER
  <item>
    <title>#{File::basename(path)}</title>
    <link>file://#{path}</link>
ENDFILEHEADER

  # get file attributes
  desc = {}
  begin 
    stat = File::stat(path)
    puts "    <date>#{stat.mtime.to_s}</date>",
         '    <description>'

    puts ["Path: #{path}<br/>",
          "Type: #{stat.ftype}<br/>",
          "Modified: #{stat.mtime}<br/>",
          "Size (in bytes): #{stat.size}<br/>",
          "Permissions: #{'%05o' % stat.mode}<br/>",
          "Owner: #{stat.uid}<br/>"].join("\n").html_escape

    { 'MIME' => '-ib', 'Content' => '-b' }.each { |title, opts|
      IO::popen("file #{opts} #{path}") { |pipe|
        puts "#{title}: #{pipe.read}<br/>".html_escape
      }
    }

    puts '    </description>',
         '  </item>'
  rescue
    puts "Error: #$!",
         '    </description>',
         '  </item>'
  end
}

puts <<-ENDFOOTER
</rss>

ENDFOOTER
