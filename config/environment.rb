require 'bundler'
require 'unirest'
require 'io/console'
require 'highline/import'

Bundler.require

PROMPT = TTY::Prompt.new
FONT = TTY::Font.new

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
