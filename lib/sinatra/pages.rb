require 'sinatra/base'
require 'haml'

module Sinatra
  class Pages < Sinatra::Base
    get '/?' do
      haml :home
    end
    
    get '/:page' do 
      haml params[:page].to_sym
    end
  end
end