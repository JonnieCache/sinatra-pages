require 'sinatra'
require 'rack/test'
require 'helpers'
require File.join(Dir.pwd, %w{lib sinatra pages})

set :environment, :test
set :views, File.join(Dir.pwd, 'views')

