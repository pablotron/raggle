-- Sample table schema for MySQL-based Raggle bookmarks table
CREATE TABLE raggle_bookmarks (
  ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL, -- title of RSS item
  url TEXT NOT NULL,           -- URL of item
  description TEXT NOT NULL,   -- description (set by user, may be '')
  tags VARCHAR(255) NOT NULL   -- tags (space-delimited, may be '')
);
