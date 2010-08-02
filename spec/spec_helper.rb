require File.join(Dir.pwd, %w{lib sinatra pages})
require 'rack/test'
require 'helpers'

ENV['RACK_ENV'] = 'test'
PAGES = ['Home','Generic',{'Generic Test'=>'Test'},{'Another Generic Test'=>{'Generic Test'=>'Test'}},'Not Found']

class TestApp < Sinatra::Base
  register Sinatra::Pages
end