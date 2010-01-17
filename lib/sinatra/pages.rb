require 'sinatra/base'
require 'haml'

module Sinatra
  class Pages < Sinatra::Base
    get '/?' do
      params[:page] = 'home'
      
      haml :home
    end
    
    get '/:page' do
      begin
        haml params[:page].to_sym
      rescue Errno::ENOENT
        halt 404
      end
    end
    
    get '/*/:page' do
      begin
        haml "#{params[:splat].first}/#{params[:page]}".to_sym
      rescue Errno::ENOENT
        halt 404
      end
    end
    
    not_found do
      params[:page] = 'not_found'
      
      haml :not_found
    end
  end
end