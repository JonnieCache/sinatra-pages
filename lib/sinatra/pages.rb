require 'sinatra/base'
require 'haml'

module Sinatra
  class Pages < Sinatra::Base
    %w[/? /:page].each do |route|
      get route do
        params[:page] = 'home' if params[:page].nil?
        
        begin
          haml params[:page].to_sym
        rescue 
          halt 404
        end
      end
    end
    
    not_found do
      haml :not_found
    end
  end
end