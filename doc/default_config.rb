$config = {
  'config_dir'            => Raggle::Path::find_home + '/.raggle',
  'config_path'           => '${config_dir}/config.rb',
  'feed_list_path'        => '${config_dir}/feeds.yaml',
  'feed_cache_path'       => '${config_dir}/feed_cache.store',
  'theme_path'            => '${config_dir}/theme.yaml',
  'grab_log_path'         => '${config_dir}/grab.log',
  'cache_lock_path'       => '${config_dir}/lock',
  'web_ui_root_path'      => Raggle::Path::find_web_ui_root,
  'web_ui_log_path'       => '${config_dir}/webrick.log',

  # feed list handling
  'load_feed_list'        => true,
  'save_feed_list'        => true,

  # feed cache handling
  'load_feed_cache'       => true,
  'save_feed_cache'       => true,

  # Log file rotation schedule.
  #
  # (valid values are 'daily', 'weekly', 'monthly', or an integer
  # indecating the number of days).
  'grab_log_age'          => 'weekly',

  # Log file rotation size.
  #
  # If the log file exceeds this size, then it will be automatically
  # rotated.
  'grab_log_size'         => 1048576,

  # Log file verbosity.
  #
  # Valid values are 'DEBUG', 'INFO', ''WARN', 'ERROR', and 'FATAL'.
  # Defaults to 'INFO' if unspecified.
  'grab_log_level'        => 'INFO',

  # save old feed items indefinitely?
  # Note: doing this with a lot of high-traffic feeds can make
  # your feed cache grow very large, very fast.  It's probably better
  # to use the per-feed --save-items command-line option.
  'save_feed_items'       => false,

  # confirm feed deletion?
  'confirm_delete'        => true,

  # theme handling
  'load_theme'            => true,
  'save_theme'            => true,

  # save stuff on crash?
  'save_on_crash'         => false,

  # abort feed thread on exception?
  'abort_on_exception'    => false,

  # feed list, feed cache, and theme lock handling
  'use_cache_lock'        => true,

  # ui options
  'focus'                 => 'auto', # ['none', 'select', 'select_first', 'auto']
  'no_desc_auto_focus'    => true,
  'scroll_wrapping'       => true,

  # log exerpt of content from feed header? (useful for debugging)
  'log_content'           => false,

  # grab in parallel (grab threads in parallel instead of serial)
  'grab_in_parallel'      => false,

  # use ASCII for window borders instead of ANSI?
  'use_ascii_only?'       => false,

  # maximum number of threads (don't set to less than 5!)
  'max_threads'           => 10,

  # thread priorities (best to leave these alone)
  'thread_priority_main'  => 10,
  'thread_priority_feed'  => 1, # parent feed grabbing thread
  'thread_priority_grab'  => 0, # child grabbing threads
  'thread_priority_gc'    => 1,
  'thread_priority_http'  => 1,
  'thread_priority_find'  => 1,
  'thread_priority_save'  => 0,

  # grab thread reap timeout (wait up to N seconds)
  'thread_reap_timeout'   => 120,

  # don't check every 60 seconds, wait for the update
  # key to be pressed (for modem users, slow computers, etc)
  'use_manual_update'     => false,

  # update feed list on startup?
  'update_on_startup'     => true,

  # proxy settings
  'proxy' => {
    'host'      => nil,
    'port'      => nil,
    'no_proxy'  => nil,
  },
  
  # send the http headers?
  'use_http_headers'      => true,

  # URL handlers
  'url_handlers'          => {
    'http'      => proc { |url, last_mod| Raggle::Engine::get_http_url(url, last_mod) },
    'https'     => proc { |url, last_mod| Raggle::Engine::get_http_url(url, last_mod) },
    'file'      => proc { |url, last_mod| Raggle::Engine::get_file_url(url, last_mod) },
    'exec'      => proc { |url, last_mod| Raggle::Engine::get_exec_url(url, last_mod) },
  },

  # RSS Enclosure Hook
  # 
  # If enabled, this command is called for each RSS enclosure Raggle
  # encounters.  Note that this command is responsible for maintaining
  # it's own cache of downloaded enclosures; Raggle passes the enclosure
  # every time it parses the feed, before it checks whether or not the
  # element was cached.  The arguments passed to the command are as
  # follows:
  #
  # * Feed Title
  # * Feed Link
  # * Item Title
  # * Item Link
  # * Enclosure URL
  # * Enclosure MIME Type
  # * Enclosure Length (in bytes)
  #
  # So, a blatantly naive implementation of an enclosure handler would 
  # probably look something like this:
  # 
  #   require 'pstore'
  #   
  #   class PStore
  #     def has_key?(key)
  #       roots.include?(key)
  #     end
  #   end
  #   
  #   # load URL cache, parse arguments
  #   cache = PStore.new('url_cache')
  #   feed_title, feed_link, title, link, url, mime_type, len = ARGV
  #   
  #   # check cache for URL
  #   exit 0 if cache.transaction { cache.has_key?(url) }
  #
  #   # generate safe filename for output file
  #   # (you'd have to write this)
  #   safe_name = gen_safe_name(url)
  #   
  #   # cache output name 
  #   cache.transaction { cache[url] = safe_name }
  #
  #   # call wget (this could just as easily be a call to
  #   # net/http, curl, or whatever else suites your fancy)
  #   Kernel.exec('wget', '-q', '-O', safe_name, url)
  #   Kernel.exit! # shouldn't ever get here
  #
  # So anyway, without any further ado, an example of the actual
  # enclosure config directive:
  #
  # 'enclosure_hook_cmd' => '/home/pabs/bin/handle_enclosures.rb',

  # Raise an exception (which generally means crash) if the URL type is
  # unknown.  You probably DON'T want to enable this.  If disabled, then
  # fall back to the default_url_handler for unknown URL types.
  'strict_url_handling'    => false,

  # if strict_url_handling is disabled, then fall back to this type 
  # when the URL handler is unknown.
  #
  # WARNING: DO NOT CHANGE THIS TO 'exec' OR 'file'. DOING SO HAS
  # POTENTIALLY SERIOUS SECURITY RAMIFICATIONS.
  'default_url_handler'   => 'http',

  # default http headers
  'http_headers'  => {
    'Accept'              => 'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,*/*;q=0.1',
    # yes Richard, there is a reason the following line looks so
    # ugly. -- Paul
    'Accept-Charset'      =>'ISO-8859-1,UTF-8;q=0.7,*;q=0.7',
    'User-Agent'          => "Raggle/#$VERSION (#{RUBY_PLATFORM}; Ruby/#{RUBY_VERSION})",
  },

  # Number of list items per "page" (wrt page up/down)
  # (if < 0, then the height of the window, minus N items)
  'page_step'             => -3,

  # date formats
  'item_date_format'      => '%c',
  'desc_date_format'      => '%c',

  # raggle http daemon settings
  'run_http_server'       => false,
  'http_server' => {
    'bind_address'        => '127.0.0.1', # localhost only
    'port'                => 2222,        # port to bind to
    'page_refresh'        => 120,         # refresh interval (feed & item wins)
    'shutdown_sleep'      => 0.5,         # seconds to wait for shutdown
    'empty_item'          => {
      'title'             => '',
      'url'               => '',
      'desc'              => '',
    },
    # NOTE:
    # document root is set as $config['web_ui_root_path'], and the
    # access log is set via $config['web_ui_log_path']
  },

  # raggle drb server settings
  'run_drb_server'        => false,
  'drb_server'            => {
    'bind_url'            => 'druby://localhost:1234',
  },

  # messages
  'msg_welcome'           => _(' Welcome to Raggle %s.'),
  'msg_exit'              => _('| Press Q to exit '),
  'msg_close'             => _('[X] '),
  'msg_grab_done'         => _(' Raggle %s'),
  'msg_load_config'       => _('Raggle: Loading config...'),
  'msg_load_list'         => _('Raggle: Loading feed list...'),
  'msg_save_list'         => _('Raggle: Saving feed list...'),
  'msg_load_cache'        => _('Raggle: Loading feed cache...'),
  'msg_save_cache'        => _('Raggle: Saving feed cache...'),
  'msg_load_theme'        => _('Raggle: Loading theme...'),
  'msg_save_theme'        => _('Raggle: Saving theme...'),
  'msg_thanks'            => _('Thanks for using Raggle!'),
  'msg_default_input'     => _('Input:'),
  'msg_new_value'         => _('New value:'),
  'msg_term_resize'       => _('Terminal Resize: '),
  'msg_links'             => _('Links:'),
  'msg_images'            => _('Images:'),
  'msg_add_feed'          => _('Enter URL:'),
  'msg_feed_added'        => _('Feed added'),
  'msg_confirm_delete'    => _('Delete current feed? (y/n)'),
  'msg_find_entry'        => _('Find:'),
  'msg_cat_title'         => _('Display Category'),
  'msg_find_feed'         => _('Find Feeds:'),
  'msg_searching'         => _(' Searching...'),
  'msg_find_title'        => _('Search Results for "%s" - %s matching feeds'),
  'msg_find_desc'         => _('Please select a feed...'),
  'msg_find_nomatches'    => _('No results found'),
  'msg_keys_title'        => _('Current Key Bindings'),
  'msg_added_existing'    => _('Warning: Added existing feed'),
  'msg_edit_title'        => _('Edit Feed Options'),
  'msg_bad_option'        => _('Warning: Bad option for %s'),
  'msg_edit_success'      => _('New option saved'),
  'msg_save_done'         => _('Configuration saved'),
  'msg_opml_input'        => _('OPML file or URI:'),
  'msg_opml_exported'     => _('OPML exported'),
  'msg_opml_imported'     => _('OPML imported'),
  'msg_bad_uri'           => _('Error: bad or empty URI'),
  'msg_exec_url'          => _('WARNING: exec url found!'),

  # bookmark messages
  'msg_bm_saving'         => _('Saving bookmark for "%s"'),
  'msg_bm_saved'          => _('Bookmark saved for "%s".'),
  'msg_bm_desc'           => _('Bookmark Description:'),
  'msg_bm_tag'            => _('Bookmark Tags (space-separated):'),
  'msg_bm_bad_type'       => _('Bad bookmark type: %s'),
  'msg_bm_bad_db_type'    => _('Unknown database type: %s'),
  'msg_bm_db_err'         => _('Database Error: %s'),
  'msg_bm_db_missing'     => _('Missing Database Engine: %s'),
  'msg_bm_del_err'        => _('Delicious Error: %s'),
  'msg_bm_del_saving'     => _('Saving Bookmark to Delicious...'),
  'msg_bm_del_missing'    => _('Error: Rubilicious not installed.'),
  'msg_bm_file_err'       => _('Error saving to \"%s\": %s'),

  # menu bar color
  'menu_bar_cols'         => 24,

  # strip external entity declarations
  # (workaround for bug in REXML 2.7.1)
  'strip_external_entities' => true,

  # input select timeout (in seconds)
  'input_select_timeout'  => 0.2,

  # http timeouts (in seconds)
  'http_open_timeout'     => 10,
  'http_read_timeout'     => 10,

  # thread sleep intervals (in seconds)
  'feed_sleep_interval'   => 60,

  # save thread sleep interval (in seconds)
  'save_sleep_interval'   => 300,

  # gc thread sleep interval (in seconds)
  'gc_sleep_interval'     => 600,

  # max results to return from syndic8
  'syndic8_max_results'   => 100,

  # grab log mode (a == append, w == write)
  'grab_log_mode'         => 'w',

  # update feeds after adding a new one?
  'update_after_add'      => true,

  # strip html from item contents?
  'strip_html_tags'       => false,

  # repair relative URLs in feed items?
  'repair_relative_urls'  => true,

  # decode html escape sequences?
  'unescape_html'         => true,

  # Force wrapping of generally unwrappable lines?
  'force_text_wrap'       => false,

  # replace unicode chars with what?
  #
  # Note: this option is meaningless when iconv character encoding
  # translation is enabled, unless 'use_iconv_munge' is true.
  'unicode_munge_str'     => '!u!',

  # character encoding used to display text from RSS feeds.
  #
  # The allowed values for 'character_encoding' vary depending on the
  # character encoding method.  If you're using the pre-0.4.0
  # REXML-style encoding translation (and you really shouldn't be unless
  # you're having problems; see 'use_iconv' below for additional
  # information), then the supported values are as follows:
  # 
  #   ISO-8859-1, UTF-8, UTF-16 and UNILE
  #
  # On the other hand, if you're using iconv-style encoding translation,
  # the list of allowed values is any character encoding supported by 
  # your version of iconv (use "iconv --list" for a full list).  Be sure
  # to omit the trailing '//' from your character_encoding value; Raggle
  # automatically appends it if it's necessary.
  #
  'character_encoding'    => 'ISO-8859-1',

  # iconv support 
  # 
  # This is the new character encoding support.  If iconv is installed
  # and iconv support is enabled (with 'use_iconv'), then use iconv
  # instead of REXML to do character encoding translations.  If
  # 'use_iconv_translit' is enabled, then use iconv transliteration to
  # approximate characters that cannot be directly represented in the
  # character encoding (specified above in 'character_encoding').
  #
  # Both 'use_iconv' and 'use_iconv_translit' default to true.
  #
  # If you've got iconv installed, you really should be using it to do
  # character conversions.  It's faster than REXML, supports a much
  # broader range of character encodings, and has intelligent built-in 
  # transliteration (as opposed to the unicode_munge_str chicanery
  # Raggle uses for the REXML-style encoding translation).
  #
  # It's probably a good idea to leave transliteration enabled.  It will
  # prevent iconv from barfing on characters it can't translate, and,
  # since Ncurses-Ruby doesn't have wide character support, it will keep
  # Ncurses from printing garbage all over the screen. 
  # 
  'use_iconv'             => true,
  'use_iconv_translit'    => true,
  'use_iconv_munge'       => true,
  'iconv_munge_illegal'   => true,

  # warn if feed refresh is set to less than this (in minutes)
  'feed_refresh_warn'     => 60,

  # default feed name and refresh rate (in minutes)
  'default_feed_title'    => _('Untitled Feed'),
  'default_feed_refresh'  => 120,
  'default_feed_priority' => 0,

  # open new screen window for browser?
  'use_screen'            => true,

  # screen command
  'screen_cmd'            => ['screen', '-t', '%s'],
  
  # browser options
  'browser'               => Raggle::Path::find_browser,
  'browser_cmd'           => ['${browser}', '%s'],

  # beep on new articles?
  'do_beep'               => false,

  # Force raggle to accept shell metacharacters in urls.
  'force_url_meta'        => false,
  # Regular expression matching shell metacharacters to not allow in URLs
  # 'shell_meta_regex'       => /([\`\$]|\#\{)/, # the #{ is to stop ruby
                                              # expansion.
                                              # Is that necessary?

  # lock feed names (don't update feed title from feed)
  # (you can lock individual feed titles with the --lock-title command)
  'lock_feed_title'       => false,

  # feed info on highlight
  'describe_hilited_feed' => true,
  'desc_show_site'        => false,
  'desc_show_url'         => false,
  'desc_show_divider'     => false,


  #################
  # yank settings #
  #################

  # a list of stuff to filter out of text that's yanked
  # you can either expand this list, or define a whole new filter
  # method with $config['yank_filter_proc'] below
  'yank_filters'          => [
    /<!--.*?-->/mi, 
    /.*<body[^>]*>/mi, 
    /<script.*?<\/script.*?>/mi,
    /<style.*?<\/style.*?>/mi,
  ],

  # filter to pass content through before appending.  the default strips
  # out the HTML header junk and comments (using the contents of
  # $config['yank_filters'] above),, hopefully getting us much closer to
  # the actual content
  'yank_filter_proc'      => proc { |html|
    filters = $config['yank_filters']
    filters.inject(html) { |ret, re| ret.gsub(re, '') }
  },

  # prefix to append before content (passed through strftime so you can
  # timestamp it)
  'yank_prefix'           => "<br/>----<p>Yanked by Raggle on %Y-%m-%d </p>----<br/>",
  
  # xpaths to item elements
  'item_element_xpaths'  => {
    'description' => [
      "./[local-name() = 'encoded' and namespace-uri() = 'http://purl.org/rss/1.0/modules/content/']",
      'description',
    ],
    'link'  => [
      'link',
      'guid', # (this needs tob e guid/attribute, isPermaLink=true)
    ],
    'date'  => [
      'date',
      "./[local-name() = 'date' and namespace-uri() = 'http://purl.org/dc/elements/1.1/']",
      'pubDate',
    ],
  },

  # key bindings
  'keys'            => ($HAVE_LIB['ncurses'] ? {
    Ncurses::KEY_RIGHT  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::next_window} ),
    ?\t                 => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::next_window} ),

    Ncurses::KEY_LEFT   => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::prev_window} ),
    ?\\                 => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::view_source} ),

    Ncurses::KEY_F12    => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::quit} ),
    ?q                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::quit} ),

    Ncurses::KEY_UP     => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_up} ),
    Ncurses::KEY_DOWN   => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_down} ),
    Ncurses::KEY_HOME   => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_top} ),
    ?0                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_top} ),
    Ncurses::KEY_END    => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_bottom} ),
    ?$                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_bottom} ),
    Ncurses::KEY_PPAGE  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_up_page} ),
    Ncurses::KEY_NPAGE  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_down_page} ),

    # vi keybindings
    ?h                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::prev_window} ),
    ?j                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_down} ),
    ?k                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_up} ),
    ?l                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::next_window} ),
    ?g                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_top} ),
    ?G                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::scroll_bottom} ),

    ?\n                 => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::select_item} ),
    ?\                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::select_item} ),

    ?u                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::move_feed_up} ),
    ?d                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::move_feed_down} ),

    ?I                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::invalidate_feed} ),
    ?e                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::edit_feed} ),

    ?/                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::find_entry(win)} ),

    Ncurses::KEY_DC     => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::delete} ),
    ?y                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::undelete_all} ),
    ?P                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::purge_deleted} ),
    ##
    # XXX: Meta can be dropped after spawned browser exits
    # So A, B, C or D should *not* be bound until this is fixed
    # -- richlowe 2003-06-22 (actually --pabs 2003-06-21)
    # ?D                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::delete} ),


    # Literal control L is horrid -- richlowe 2003-06-26
    ?\                => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::resize_term} ),

    ?s                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::sort_feeds} ),

    ?o                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link} ),

    ?m                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::mark_items_as_read} ),
    ?M                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::mark_items_as_unread} ),
    ?N                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::mark_current_as_unread} ),

    ?!                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::drop_to_shell} ),

    ?p                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::select_prev_unread} ),
    ?n                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::select_next_unread} ),

    ?r                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::lower_feed_priority} ),
    ?R                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::raise_feed_priority} ),

    ?U                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::manual_update} ),
    ?S                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::manual_save} ),
    ?a                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::add_feed} ),
    ?O                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::opml} ),

    # i know this is using 'c'.. we'll see if this fucks us (see note
    # about 'C' above)
    # -- pabs (Sat Mar 20 21:10:55 2004)
    ?c                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::gui_cat_list} ),
    ?f                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::gui_find_feed} ),
    ?C                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::close_window} ),
    ?                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::close_window} ),

    ??                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::show_key_bindings} ),
    ?B                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::save_bookmark} ),

    ?1                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(1)} ),
    ?2                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(2)} ),
    ?3                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(3)} ),
    ?4                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(4)} ),
    ?5                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(5)} ),
    ?6                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(6)} ),
    ?7                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(7)} ),
    ?8                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(8)} ),
    ?9                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::open_link(9)} ),
    ?Y                  => proc( %{|win, key| Raggle::Interfaces::NcursesInterface::Key::yank_link } ),
  } : {}),

  # color palette (referenced by themes)
  'color_palette'         => ($HAVE_LIB['ncurses'] ? [
    [  1, Ncurses::COLOR_WHITE,    Ncurses::COLOR_BLACK   ],
    [  2, Ncurses::COLOR_RED,      Ncurses::COLOR_BLACK   ],
    [  3, Ncurses::COLOR_GREEN,    Ncurses::COLOR_BLACK   ],
    [  4, Ncurses::COLOR_BLUE,     Ncurses::COLOR_BLACK   ],
    [  5, Ncurses::COLOR_MAGENTA,  Ncurses::COLOR_BLACK   ],
    [  6, Ncurses::COLOR_CYAN,     Ncurses::COLOR_BLACK   ],
    [  7, Ncurses::COLOR_YELLOW,   Ncurses::COLOR_BLACK   ],
    [ 11, Ncurses::COLOR_BLACK,    Ncurses::COLOR_WHITE   ],
    [ 12, Ncurses::COLOR_BLACK,    Ncurses::COLOR_RED     ],
    [ 13, Ncurses::COLOR_BLACK,    Ncurses::COLOR_GREEN   ],
    [ 14, Ncurses::COLOR_BLACK,    Ncurses::COLOR_BLUE    ],
    [ 15, Ncurses::COLOR_BLACK,    Ncurses::COLOR_MAGENTA ],
    [ 16, Ncurses::COLOR_BLACK,    Ncurses::COLOR_CYAN    ],
    [ 17, Ncurses::COLOR_BLACK,    Ncurses::COLOR_YELLOW  ],
    [ 21, Ncurses::COLOR_BLACK,    Ncurses::COLOR_WHITE   ],
    [ 22, Ncurses::COLOR_WHITE,    Ncurses::COLOR_RED     ],
    [ 23, Ncurses::COLOR_WHITE,    Ncurses::COLOR_GREEN   ],
    [ 24, Ncurses::COLOR_WHITE,    Ncurses::COLOR_BLUE    ],
    [ 25, Ncurses::COLOR_WHITE,    Ncurses::COLOR_MAGENTA ],
    [ 26, Ncurses::COLOR_WHITE,    Ncurses::COLOR_CYAN    ],
    [ 27, Ncurses::COLOR_WHITE,    Ncurses::COLOR_YELLOW  ],
    [ 31, Ncurses::COLOR_WHITE,    Ncurses::COLOR_CYAN    ],
    [ 32, Ncurses::COLOR_RED,      Ncurses::COLOR_CYAN    ],
    [ 33, Ncurses::COLOR_GREEN,    Ncurses::COLOR_CYAN    ],
    [ 34, Ncurses::COLOR_BLUE,     Ncurses::COLOR_CYAN    ],
    [ 35, Ncurses::COLOR_MAGENTA,  Ncurses::COLOR_CYAN    ],
    [ 36, Ncurses::COLOR_BLACK,    Ncurses::COLOR_CYAN    ],
    [ 37, Ncurses::COLOR_YELLOW,   Ncurses::COLOR_CYAN    ],
  ] : []),

  'attr_palette'          => ($HAVE_LIB['ncurses'] ? {
    'normal'        => Ncurses::A_NORMAL,
    'normal'        => Ncurses::A_NORMAL,
    'standout'      => Ncurses::A_STANDOUT,
    'underline'     => Ncurses::A_UNDERLINE,
    'reverse'       => Ncurses::A_REVERSE,
    'blink'         => Ncurses::A_BLINK,
    'dim'           => Ncurses::A_DIM,
    'bold'          => Ncurses::A_BOLD,
    'protect'       => Ncurses::A_PROTECT,
    'invis'         => Ncurses::A_INVIS,
    'altcharset'    => Ncurses::A_ALTCHARSET,
    'chartext'      => Ncurses::A_CHARTEXT,
  } : {}),

  # default theme settings
  'theme'           => {
    # theme information
    'name'          => 'Default Theme',
    'author'        => 'Paul Duncan <pabs@pablotron.org>',
    'url'           => 'http://www.raggle.org/',

    # window order (order for window changes, etc)
    'window_order'  => ['feed', 'item', 'desc'],
    
    # status bar color
    'status_bar_cols'       => 24,

    # feed window attributes
    'win_feed'      => {
      'key'         => 'feed',
      'title'       => _('Feeds'),
      'coords'      => [0, 0, 25, -1],
      'type'        => 'list',
      'colors'      => { 
        'title'     => 1,
        'text'      => 1,
        'h_text'    => 16,
        'box'       => 4,
        'a_title'   => 21,
        # 'a_title'   => 36,
        'a_box'     => 3,
        'unread'    => 6,
        'h_unread'  => 36,
        'empty'     => 2,
        'h_empty'     => 32,
      },
    },

    # item window attributes
    'win_item'      => {
      'key'         => 'item',
      'title'       => _('Items'),
      'coords'      => [25, 0, -1, 15],
      'type'        => 'list',
      'colors'      => {
        'title'     => 1,
        'text'      => 1,
        'h_text'    => 16,
        'box'       => 4,
        'a_title'   => 21,
        'a_box'     => 3,
        'unread'    => 6,
        'h_unread'  => 36,
      },
    },

    # desc window attributes
    'win_desc'      => {
      'key'         => 'desc',
      'title'       => _('Description'),
      'coords'      => [25, 15, -1, -1],
      'type'        => 'text',
      'colors'      => {
        'title'     => 1,
        'text'      => 1,
        'h_text'    => 16,
        'box'       => 4,
        'a_title'   => 21,
        'a_box'     => 3,
        'url'       => 6,
        'date'      => 6,

        'f_title'   => [1, 'bold'],
        'f_update'  => 1,
        'f_url'     => 1,
        'f_site'    => 1,
        'f_error'   => 2,
        'f_desc'    => 1,
      },
    },
  },

  # bookmark settings
  # how bookmarks are saved when you press 'B' in the
  # Ncurses interface
  'bookmark' => [
    # basic CSV bookmark file
    { :type => :csv_file,
      :path => '${config_dir}/bookmarks.csv', 

      # optional settings
      # don't prompt for item description (default: false)
      :no_desc => true,
      # don't prompt for tags (default: false)
      # :no_tags => false,
      # inherit tags from parent feed? (default: true)
      # :inherit_tags => true,
    },

    # pass bookmark to an arbitrary file
    # note: doesn't check for success on exit just yet
# 
#     { :type => :exec,
#       # path to file to execute
#       # arguments are passed in the following order:
#       #   title, url, tags, desc
#       :path => File::join(ENV['HOME'], 'bin', 'raggle_delicious.rb'),
# 
#       # optional settings
#       # don't prompt for item description (default: false)
#       :no_desc => true,
#       # don't prompt for tags (default: false)
#       # :no_tags => false,
#       # inherit tags from parent feed? (default: true)
#       # :inherit_tags => true,
#     },
# 

    # save bookmarks to sqlite
    # note: requires the sqlite-ruby library, and the bookmark
    # database must exist, with the appropriate table
# 
#     { :type   => :db,
#       :dbtype => :sqlite,
#     
#       # path to database file
#       # note: database file MUST already exist!
#       :path   => '${config_dir}/bookmarks.db',
# 
#       # name of table to save bookmarks into
#       # note: this table MUST already exist!
#       :table  => 'raggle_bookmarks',
# 
#       # list of fields (note: you can omit any of these)
#       :fields => {
#         :title  => 'title',
#         :desc   => 'description',
#         :url    => 'url',
#         :tags   => 'tags',
#       },
# 
#       # optional settings
#       # don't prompt for descriptions (default: false)
#       # :no_desc => false,
#       # don't prompt for tags (default: false)
#       # :no_tags => false,
#       # inherit tags from parent feed? (default: true)
#       # :inherit_tags => true,
#     },
# 

    # save bookmarks to mysql
    # note: requires the sqlite-ruby library, and the bookmark
    # database must exist, with the appropriate table
# 
#     { :type   => :db,
#       :dbtype => :mysql,
#     
#       # db server, username, password, and name of database to use
#       :host   => 'HOSTNAME', # (use 'localhost' if it's on this machine)
#       :user   => 'USERNAME',
#       :pass   => 'PASSWORD',
#       :dbname => 'raggle_database',
# 
#       # name of table to save bookmarks into
#       # note: this table MUST already exist!
#       :table  => 'raggle_bookmarks',
# 
#       # list of fields (note: you can omit any of these)
#       :fields => {
#         :title  => 'title',
#         :desc   => 'description',
#         :url    => 'url',
#         :tags   => 'tags',
#       },
# 
#       # optional settings
#       # don't prompt for descriptions (default: false)
#       # :no_desc => false,
#       # don't prompt for tags (default: false)
#       # :no_tags => false,
#       # inherit tags from parent feed? (default: true)
#       # :inherit_tags => true,
#     },
# 
  ],

  # live feeds
  'feeds'    => Raggle::Feed::List.new,

  # debugging / internal options (don't touch)
  'use_raw_mode'  => true,
  'use_noecho'    => true,

  'default_feeds' => [
    { 'title'     => 'Raggle Help',
      'url'       => "http://raggle.org/rss/help/",
      'site'      => 'http://raggle.org/',
      'refresh'   => 240,
      'updated'   => 0,
      'desc'      => '',
      'category'  => 'Raggle',
      'items'     => [ ],
      'priority'  => 2,
    },
    { 'title'     => 'Alternet',
      'url'       => 'http://alternet.org/module/feed/rss/',
      'site'      => 'http://alternet.org/',
      'desc'      => 'Alternative News and Information.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Politics News',
      'items'     => [ ],
    },
    { 'title'     => 'Daily Daemon News',
      'url'       => 'http://daily.daemonnews.org/ddn.rdf.php3',
      'site'      => 'http://daemonnews.org/',
      'desc'      => 'Daily Daemon News',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'FreshMeat',
      'url'       => 'http://freshmeat.net/backend/fm-releases-global.xml',
      'site'      => 'http://freshmeat.net/',
      'desc'      => 'FreshMeat.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Halffull.org',
      'url'       => 'http://halffull.org/feed/',
      'site'      => 'http://halffull.org/',
      'desc'      => 'Thomas Kirchner\'s personal site.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs Tech',
      'items'     => [ ],
    },
    { 'title'     => 'KernelTrap',
      'url'       => 'http://kerneltrap.org/node/feed',
      'site'      => 'http://kerneltrap.org/',
      'desc'      => 'KernelTrap',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Kuro5hin',
      'url'       => 'http://kuro5hin.org/backend.rdf',
      'site'      => 'http://kuro5hin.org/',
      'desc'      => 'Kuro5hin',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech Politics',
      'items'     => [ ],
    },
    { 'title'     => 'Linux Weekly News',
      'url'       => 'http://www.lwn.net/headlines/newrss',
      'site'      => 'http://www.lwn.net/',
      'desc'      => 'Linux Weekly News',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Linuxbrit',
      'url'       => 'http://linuxbrit.co.uk/feed/rss2/',
      'site'      => 'http://linuxbrit.co.uk/',
      'desc'      => 'Tom Gilbert\'s personal site.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs',
      'items'     => [ ],
    },
    { 'title'     => 'Pablotron',
      'url'       => 'http://www.pablotron.org/rss/',
      'site'      => 'http://www.pablotron.org/',
      'desc'      => 'Paul Duncan\'s personal site.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Paul Duncan.org',
      'url'       => 'http://paulduncan.org/rss/',
      'site'      => 'http://paulduncan.org/',
      'desc'      => 'Paul Duncan\'s other personal site.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs',
      'items'     => [ ],
    },
    { 'title'     => 'Raggle: News',
      'url'       => 'http://raggle.org/rss/',
      'site'      => 'http://raggle.org/',
      'desc'      => 'Raggle News',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech Raggle',
      'items'     => [ ],
      'priority'  => 1,
    },
    { 'title'     => 'Slashdot',
      'url'       => 'http://slashdot.org/slashdot.rss',
      'site'      => 'http://slashdot.org/',
      'desc'      => 'Slashdot',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech News',
      'items'     => [ ],
    },
    { 'title'     => 'Reuters: Oddly Enough',
      'url'       => 'http://www.microsite.reuters.com/rss/oddlyEnoughNews',
      'site'      => 'http://reuters.com/',
      'desc'      => 'Reuters oddly enough.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Funny News',
      'items'     => [ ],
    },
    { 'title'     => 'This Modern World',
      'url'       => 'http://www.thismodernworld.com/index.rdf',
      'site'      => 'http://www.thismodernworld.com/',
      'desc'      => 'This Modern World',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs Politics',
      'items'     => [ ],
    },
    { 'title'     => 'W3C',
      'url'       => 'http://www.w3.org/2000/08/w3c-synd/home.rss',
      'site'      => 'http://www.w3.org/',
      'desc'      => 'W3C',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Yahoo! News - Tech',
      'url'       => 'http://rss.news.yahoo.com/rss/tech',
      'site'      => 'http://news.yahoo.com/',
      'desc'      => 'yahoo tech',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech News',
      'items'     => [ ],
    },
    { 'title'     => 'Yahoo! News - Top Stories',
      'url'       => 'http://rss.news.yahoo.com/rss/topstories',
      'site'      => 'http://news.yahoo.com/',
      'desc'      => 'yahoo top stories',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'News',
      'items'     => [ ],
    },
    { 'title'     => 'Yahoo! News - World',
      'url'       => 'http://rss.news.yahoo.com/rss/world',
      'site'      => 'http://news.yahoo.com/',
      'desc'      => 'yahoo world',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Politics News',
      'items'     => [ ],
    },
  ],
}
