# -*- Mode: Ruby -*-

#######################################################################
# default_config.rb - default configuration for Raggle                #
#                                                                     #
# This file is distributed with Raggle.  Please see the Raggle page   #
# at http://www.pablotron.org/software/raggle/ for the latest version #
# of this file.                                                       #
#######################################################################

##################
# default config #
##################
$config = {
  'config_dir'            => ENV['HOME'] + '/.raggle',
  'config_path'           => '${config_dir}/config.rb',
  'feed_list_path'        => '${config_dir}/feeds.yaml',
  'feed_cache_path'       => '${config_dir}/feed_cache.store',
  'theme_path'            => '${config_dir}/theme.yaml',
  'grab_log_path'         => '${config_dir}/grab.log',
  'cache_lock_path'       => '${config_dir}/lock',

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

  # feed list, feed cache, and theme lock handling
  'use_cache_lock'        => true,

  # ui options
  'focus'                 => 'select', # ['none', 'select', 'auto']
  'no_desc_auto_focus'    => true,
  'scroll_wrapping'       => true,

  # Number of list items per "page" (wrt page up/down)
  # (if < 0, then the height of the window, minus N items)
  'page_step'             => -3,

  # date formats
  'item_date_format'      => '%c',
  'desc_date_format'      => '%c',

  # messages
  'msg_welcome'           => " Welcome to Raggle #{$VERSION}.",
  'msg_exit'              => "| Press Q to exit ",
  'msg_close'             => '[X] ',
  'msg_load_config'       => 'Raggle: Loading config...',
  'msg_load_list'         => 'Raggle: Loading feed list...',
  'msg_save_list'         => 'Raggle: Saving feed list...',
  'msg_load_cache'        => 'Raggle: Loading feed cache...',
  'msg_save_cache'        => 'Raggle: Saving feed cache...',
  'msg_load_theme'        => 'Raggle: Loading theme...',
  'msg_save_theme'        => 'Raggle: Saving theme...',
  'msg_thanks'            => 'Thanks for using Raggle!',
  'msg_term_resize'       => 'Terminal Resize: ',

  # menu bar color
  'menu_bar_cols'         => 24,

  # input select timeout (in seconds)
  'input_select_timeout'  => 0.2,

  # feed sleep interval (in seconds)
  'feed_sleep_interval'   => 60,

  # grab log mode (a == append, w == write)
  'grab_log_mode'         => 'w',

  # strip html from item contents?
  'strip_html_tags'       => true,

  # decode html escape sequences?
  'unescape_html'         => true,

  # replace unicode chars with what?
  'unicode_munge_str'     => 'ZZ',

  # warn if feed refresh is set to less than this
  'feed_refresh_warn'     => 60,

  # open new screen window for browser?
  'use_screen'            => true,

  # screen command
  'screen_cmd'            => 'screen -t "%s"',
  
  # browser options
  'browser'               => find_browser,
  'browser_cmd'           => '${browser} %s',

  # lock feed names (don't update feed title from feed)
  # (you can lock individual feed titles with the --lock-title command)
  'lock_feed_title'       => false,

  # feed info on highlight
  'describe_hilited_feed' => true,
  'desc_show_site'        => false,
  'desc_show_url'         => false,
  'desc_show_divider'     => false,

  # key bindings
  'keys'            => {
    Ncurses::KEY_RIGHT  => proc { |win, key| Key::next_window },
    ?\t                 => proc { |win, key| Key::next_window },

    Ncurses::KEY_LEFT   => proc { |win, key| Key::prev_window },
    ?\\                 => proc { |win, key| Key::prev_window },

    Ncurses::KEY_F12    => proc { |win, key| Key::quit },
    ?q                  => proc { |win, key| Key::quit },

    Ncurses::KEY_UP     => proc { |win, key| Key::scroll_up },
    Ncurses::KEY_DOWN   => proc { |win, key| Key::scroll_down },
    Ncurses::KEY_END    => proc { |win, key| Key::scroll_bottom },
    Ncurses::KEY_PPAGE  => proc { |win, key| Key::scroll_up_page },
    Ncurses::KEY_NPAGE  => proc { |win, key| Key::scroll_down_page },

    ?\n                 => proc { |win, key| Key::select_item },
    ?\                  => proc { |win, key| Key::select_item },

    ?u                  => proc { |win, key| Key::move_item_up },
    ?d                  => proc { |win, key| Key::move_item_down },

    Ncurses::KEY_DC     => proc { |win, key| Key::delete },
    ##
    # XXX: Meta can be dropped after spawned browser exits
    # So A, B, C or D should *not* be bound until this is fixed
    # -- richlowe 2003-06-22 (actually --pabs 2003-06-21)
    # ?D                  => proc { |win, key| Key::delete },

    Ncurses::KEY_RESIZE => proc { |win, key| resize_term },

    ?s                  => proc { |win, key| Key::sort_feeds },

    ?o                  => proc { |win, key| Key::open_link },
  },

  # color palette (referenced by themes)
  'color_palette'         => [
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
  ],

  'attr_palette'          => {
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
  },

  # default theme settings
  'theme'           => {
    # theme information
    'name'          => 'Default Theme',
    'author'        => 'Paul Duncan <pabs@pablotron.org>',
    'url'           => 'http://www.pablotron.org/software/raggle/',

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

  # default feeds
  'default_feeds' => [ ],
}
