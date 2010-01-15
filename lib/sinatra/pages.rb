require 'sinatra/base'
require 'haml'

module Sinatra
  class Pages < Sinatra::Base
    get '/' do
      haml :home
    end
  end
end