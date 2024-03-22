--
-- Database: writefreely
--

-- --------------------------------------------------------

--
-- Table structure for table accesstokens
--

CREATE TABLE IF NOT EXISTS accesstokens (
  token bytea NOT NULL,
  user_id int NOT NULL,
  sudo smallint NOT NULL DEFAULT '0',
  one_time smallint NOT NULL DEFAULT '0',
  created timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires timestamp(0) DEFAULT NULL,
  user_agent varchar(255) DEFAULT NULL,
  PRIMARY KEY (token)
);

-- --------------------------------------------------------

--
-- Table structure for table appcontent
--

CREATE TABLE IF NOT EXISTS appcontent (
  id varchar(36) NOT NULL,
  content text NOT NULL,
  updated timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

-- --------------------------------------------------------

--
-- Table structure for table appmigrations
--

CREATE TABLE IF NOT EXISTS appmigrations (
  version int NOT NULL,
  migrated timestamp(0) NOT NULL,
  result text NOT NULL
);

-- --------------------------------------------------------

--
-- Table structure for table collectionattributes
--

CREATE TABLE IF NOT EXISTS collectionattributes (
  collection_id int NOT NULL,
  attribute varchar(128) NOT NULL,
  value varchar(255) NOT NULL,
  PRIMARY KEY (collection_id,attribute)
);

-- --------------------------------------------------------

--
-- Table structure for table collectionkeys
--

CREATE TABLE IF NOT EXISTS collectionkeys (
  collection_id int NOT NULL,
  public_key bytea NOT NULL,
  private_key bytea NOT NULL,
  PRIMARY KEY (collection_id)
);

-- --------------------------------------------------------

--
-- Table structure for table collectionpasswords
--

CREATE TABLE IF NOT EXISTS collectionpasswords (
  collection_id int NOT NULL,
  password char(60) NOT NULL,
  PRIMARY KEY (collection_id)
);

-- --------------------------------------------------------

--
-- Table structure for table collectionredirects
--

CREATE TABLE IF NOT EXISTS collectionredirects (
  prev_alias varchar(100) NOT NULL,
  new_alias varchar(100) NOT NULL,
  PRIMARY KEY (prev_alias)
);

-- --------------------------------------------------------

--
-- Table structure for table collections
--

CREATE TABLE IF NOT EXISTS collections (
  id SERIAL PRIMARY KEY,
  alias varchar(100) DEFAULT NULL,
  title varchar(255) NOT NULL,
  description varchar(160) NOT NULL,
  style_sheet text,
  script text,
  format varchar(8) DEFAULT NULL,
  privacy smallint NOT NULL,
  owner_id int NOT NULL,
  view_count int NOT NULL,
  CONSTRAINT alias UNIQUE (alias)
);

-- --------------------------------------------------------

--
-- Table structure for table posts
--

CREATE TABLE IF NOT EXISTS posts (
  id char(16) NOT NULL,
  slug varchar(100) DEFAULT NULL,
  modify_token char(32) DEFAULT NULL,
  text_appearance char(4) NOT NULL DEFAULT 'norm',
  language char(2) DEFAULT NULL,
  rtl smallint DEFAULT NULL,
  privacy smallint NOT NULL,
  owner_id int DEFAULT NULL,
  collection_id int DEFAULT NULL,
  pinned_position smallint CHECK (pinned_position > 0) DEFAULT NULL,
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  view_count int NOT NULL,
  title varchar(160) NOT NULL,
  content text NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT id_slug UNIQUE (collection_id,slug),
  CONSTRAINT owner_id UNIQUE (owner_id,id),
  CONSTRAINT privacy_id UNIQUE (privacy,id)
);

-- --------------------------------------------------------

--
-- Table structure for table remotefollows
--

CREATE TABLE IF NOT EXISTS remotefollows (
  collection_id int NOT NULL,
  remote_user_id int NOT NULL,
  created timestamp(0) NOT NULL,
  PRIMARY KEY (collection_id,remote_user_id)
);

-- --------------------------------------------------------

--
-- Table structure for table remoteuserkeys
--

CREATE TABLE IF NOT EXISTS remoteuserkeys (
  id varchar(255) NOT NULL,
  remote_user_id int NOT NULL,
  public_key bytea NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT follower_id UNIQUE (remote_user_id)
);

-- --------------------------------------------------------

--
-- Table structure for table remoteusers
--

CREATE TABLE IF NOT EXISTS remoteusers (
  id SERIAL PRIMARY KEY,
  actor_id varchar(255) NOT NULL,
  inbox varchar(255) NOT NULL,
  shared_inbox varchar(255) NOT NULL,
  CONSTRAINT collection_id UNIQUE (actor_id)
);

-- --------------------------------------------------------

--
-- Table structure for table userattributes
--

CREATE TABLE IF NOT EXISTS userattributes (
  user_id int NOT NULL,
  attribute varchar(64) NOT NULL,
  value varchar(255) NOT NULL,
  PRIMARY KEY (user_id,attribute)
);

-- --------------------------------------------------------

--
-- Table structure for table userinvites
--

CREATE TABLE IF NOT EXISTS userinvites (
  id char(6) NOT NULL,
  owner_id int NOT NULL,
  max_uses smallint DEFAULT NULL,
  created timestamp(0) NOT NULL,
  expires timestamp(0) DEFAULT NULL,
  inactive smallint NOT NULL
);

-- --------------------------------------------------------

--
-- Table structure for table users
--

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username varchar(100) NOT NULL,
  password char(60) NOT NULL,
  email bytea DEFAULT NULL,
  created timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT username UNIQUE (username)
);

-- --------------------------------------------------------

--
-- Table structure for table usersinvited
--

CREATE TABLE IF NOT EXISTS usersinvited (
  invite_id char(6) NOT NULL,
  user_id int NOT NULL
);
