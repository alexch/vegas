require File.expand_path("#{File.dirname(__FILE__)}/setup")

RAILS_ENV = :development
DB.connect_to(:development)
RAILS_ROOT = File.dirname(__FILE__)
