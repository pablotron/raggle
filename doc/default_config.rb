##################
# default config #
##################
$config = {
  'config_dir'            => Path::find_home + '/.raggle',
  'config_path'           => '${config_dir}/config.rb',
  'feed_list_path'        => '${config_dir}/feeds.yaml',
  'feed_cache_path'       => '${config_dir}/feed_cache.store',
  'theme_path'            => '${config_dir}/theme.yaml',
  'grab_log_path'         => '${config_dir}/grab.log',
  'cache_lock_path'       => '${config_dir}/lock',
  'web_ui_root_path'      => Path::find_web_ui_root,
  'web_ui_log_path'       => '${config_dir}/webrick.log',

  # feed list handling
  'load_feed_list'        => true,
  'save_feed_list'        => true,

  # feed cache handling
  'load_feed_cache'       => true,
  'save_feed_cache'       => true,

  # save old feed items indefinitely?
  # Note: doing this with a lot of high-traffic feeds can make
  # your feed cache grow very large, very fast.  It's probably better
  # to use the per-feed --save-items command-line option.
  'save_feed_items'       => false,

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

  # grab in parallel (grab threads in parallel instead of serial)
  'grab_in_parallel'      => false,

  # use ASCII for window borders instead of ANSI?
  'use_ascii_only?'       => false,

  # maximum number of threads (don't set to less than 5!)
  'max_threads'           => 7,

  # thread priorities (best to leave these alone)
  'thread_priority_main'  => 10,
  'thread_priority_feed'  => 1, # parent feed grabbing thread
  'thread_priority_grab'  => 0, # child grabbing threads
  'thread_priority_gc'    => 1,
  'thread_priority_http'  => 1,

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
    'http'      => proc { |url, last_mod| Feed::get_http_url(url, last_mod) },
    'https'     => proc { |url, last_mod| Feed::get_http_url(url, last_mod) },
    'file'      => proc { |url, last_mod| Feed::get_file_url(url, last_mod) },
    'exec'      => proc { |url, last_mod| Feed::get_exec_url(url, last_mod) },
  },

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
    'User-Agent'          => "Raggle/#$VERSION (#{PLATFORM}; Ruby/#{VERSION})",
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
  'msg_welcome'           => " Welcome to Raggle #{$VERSION}.",
  'msg_exit'              => "| Press Q to exit ",
  'msg_close'             => '[X] ',
  'msg_grab_done'         => " Raggle #{$VERSION}",
  'msg_load_config'       => 'Raggle: Loading config...',
  'msg_load_list'         => 'Raggle: Loading feed list...',
  'msg_save_list'         => 'Raggle: Saving feed list...',
  'msg_load_cache'        => 'Raggle: Loading feed cache...',
  'msg_save_cache'        => 'Raggle: Saving feed cache...',
  'msg_load_theme'        => 'Raggle: Loading theme...',
  'msg_save_theme'        => 'Raggle: Saving theme...',
  'msg_thanks'            => 'Thanks for using Raggle!',
  'msg_term_resize'       => 'Terminal Resize: ',
  'msg_links'             => 'Links:',
  'msg_add_feed'          => 'Enter URL:',
  'msg_find_entry'        => 'Find:',

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

  # gc thread sleep interval (in seconds)
  'gc_sleep_interval'     => 600,

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
  'unicode_munge_str'     => '!u!',

  # character encoding used to display text
  # from RSS feeds.
  #
  # Supported encodings are: ISO-8859-1, UTF-8, UTF-16 and UNILE
  'character_encoding'    => 'ISO-8859-1',

  # warn if feed refresh is set to less than this
  'feed_refresh_warn'     => 60,

  # default feed name and refresh rate
  'default_feed_title'    => 'Untitled Feed',
  'default_feed_refresh'  => 120,

  # open new screen window for browser?
  'use_screen'            => true,

  # screen command
  'screen_cmd'            => ['screen', '-t', '%s'],
  
  # browser options
  'browser'               => Path::find_browser,
  'browser_cmd'           => ['${browser}', '%s'],

  # Force raggle to accept shell metacharacters in urls.
  'force_url_meta'        => false,
  # Regular expression matching shell metacharacters to not allow in URLs
  'shell_meta_regex'       => /([\`\$]|\#\{)/, # the #{ is to stop ruby
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
    Ncurses::KEY_RIGHT  => proc { |win, key| Key::next_window },
    ?\t                 => proc { |win, key| Key::next_window },

    Ncurses::KEY_LEFT   => proc { |win, key| Key::prev_window },
    ?\\                 => proc { |win, key| Key::view_source },

    Ncurses::KEY_F12    => proc { |win, key| Key::quit },
    ?q                  => proc { |win, key| Key::quit },

    Ncurses::KEY_UP     => proc { |win, key| Key::scroll_up },
    Ncurses::KEY_DOWN   => proc { |win, key| Key::scroll_down },
    Ncurses::KEY_HOME   => proc { |win, key| Key::scroll_top },
    ?0                  => proc { |win, key| Key::scroll_top },
    Ncurses::KEY_END    => proc { |win, key| Key::scroll_bottom },
    ?$                  => proc { |win, key| Key::scroll_bottom },
    Ncurses::KEY_PPAGE  => proc { |win, key| Key::scroll_up_page },
    Ncurses::KEY_NPAGE  => proc { |win, key| Key::scroll_down_page },

    # vi keybindings
    ?h                  => proc { |win, key| Key::prev_window },
    ?j                  => proc { |win, key| Key::scroll_down },
    ?k                  => proc { |win, key| Key::scroll_up },
    ?l                  => proc { |win, key| Key::next_window },

    ?\n                 => proc { |win, key| Key::select_item },
    ?\                  => proc { |win, key| Key::select_item },

    ?u                  => proc { |win, key| Key::move_item_up },
    ?d                  => proc { |win, key| Key::move_item_down },

    ?I                  => proc { |win, key| Key::invalidate_feed },

    ?/                  => proc { |win, key| Key::find_entry(win) },

    Ncurses::KEY_DC     => proc { |win, key| Key::delete },
    ##
    # XXX: Meta can be dropped after spawned browser exits
    # So A, B, C or D should *not* be bound until this is fixed
    # -- richlowe 2003-06-22 (actually --pabs 2003-06-21)
    # ?D                  => proc { |win, key| Key::delete },


    # Literal control L is horrid -- richlowe 2003-06-26
    ?\                => proc { |win, key| resize_term },
    Ncurses::KEY_RESIZE => proc { |win, key| resize_term },

    ?s                  => proc { |win, key| Key::sort_feeds },

    ?o                  => proc { |win, key| Key::open_link },

    ?m                  => proc { |win, key| mark_items_as_read },

    ?!                  => proc { |win, key| drop_to_shell },

    ?p                  => proc { |win, key| select_prev_unread },
    ?n                  => proc { |win, key| select_next_unread },

    ?U                  => proc { |win, key| Key::manual_update },
    ?a                  => proc { |win, key| Key::gui_add_feed },
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
      'title'       => 'Feeds',
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
      'title'       => 'Items',
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
      'title'       => 'Description',
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

  # live feeds
  'feeds'    => FeedList.new,

  # debugging / internal options (don't touch)
  'use_raw_mode'  => true,
  'use_noecho'    => true,

  'default_feeds' => [
    { 'title'     => '  Raggle Help', # add a space so sorting puts it at top
      'url'       => "http://www.raggle.org/rss/help/",
      'site'      => 'http://www.raggle.org/',
      'refresh'   => 240,
      'updated'   => -1,
      'desc'      => '',
      'category'  => 'Raggle',
      'items'     => [ ],
    },
    { 'title'     => 'Alternet',
      'url'       => 'http://www.alternet.org/rss/rss.xml',
      'site'      => 'http://www.alternet.org/',
      'desc'      => 'Alternative News and Information.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Politics,News',
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
      'url'       => 'http://themes.freshmeat.net/backend/fm-newsletter.rdf',
      'site'      => 'http://www.freshmeat.net/',
      'desc'      => 'FreshMeat.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'KernelTrap',
      'url'       => 'http://kerneltrap.org/node/feed',
      'site'      => 'http://www.kerneltrap.org/',
      'desc'      => 'KernelTrap',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Kuro5hin',
      'url'       => 'http://www.kuro5hin.org/backend.rdf',
      'site'      => 'http://www.kuro5hin.org/',
      'desc'      => 'Kuro5hin',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Linux Weekly News',
      'url'       => 'http://www.lwn.net/headlines/rss',
      'site'      => 'http://www.lwn.net/',
      'desc'      => 'Linux Weekly News',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech',
      'items'     => [ ],
    },
    { 'title'     => 'Linuxbrit.co.uk',
      'url'       => 'http://www.linuxbrit.co.uk/rss.php',
      'site'      => 'http://www.linuxbrit.co.uk/',
      'desc'      => 'Linuxbrit.co.uk',
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
      'category'  => 'Blogs',
      'items'     => [ ],
    },
    { 'title'     => 'Paul Duncan.org',
      'url'       => 'http://www.paulduncan.org/rss/',
      'site'      => 'http://www.paulduncan.org/',
      'desc'      => 'Paul Duncan\'s other personal site.',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs',
      'items'     => [ ],
    },
    { 'title'     => 'Pigdog Journal',
      'url'       => 'http://www.pigdog.org/pigdog.rdf',
      'site'      => 'http://www.pigdog.org/',
      'desc'      => 'Pigdog Journal',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Politics,News',
      'items'     => [ ],
    },
    { 'title'     => 'Raggle: News',
      'url'       => 'http://raggle.org/rss/',
      'site'      => 'http://www.raggle.org/',
      'desc'      => 'Raggle News',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech,Raggle',
      'items'     => [ ],
    },
    { 'title'     => 'Richlowe.net',
      'url'       => 'http://richlowe.net/diary/index.rss',
      'site'      => 'http://www.richlowe.net/',
      'desc'      => 'Richlowe.net',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs',
      'items'     => [ ],
    },
    { 'title'     => 'Slashdot',
      'url'       => 'http://slashdot.org/slashdot.rss',
      'site'      => 'http://www.slashdot.org/',
      'desc'      => 'Slashdot',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Tech,News',
      'items'     => [ ],
    },
    { 'title'     => 'This Modern World',
      'url'       => 'http://www.thismodernworld.com/index.rdf',
      'site'      => 'http://www.thismodernworld.com/',
      'desc'      => 'This Modern World',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs,Politics',
      'items'     => [ ],
    },
    { 'title'     => 'Tynian.net',
      'url'       => 'http://tynian.net/rss/',
      'site'      => 'http://tynian.net/',
      'desc'      => 'tynian.net',
      'refresh'   => 120,
      'updated'   => 0,
      'category'  => 'Blogs',
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
      'category'  => 'Tech,News',
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
      'category'  => 'Politics,News',
      'items'     => [ ],
    },
  ],
}
