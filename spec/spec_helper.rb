require 'sinatra'
require 'rack/test'
require 'fileutils'
require File.join(Dir.pwd, %w{lib sinatra pages})

set :environment, :test
set :views, "#{Dir.pwd}/views"