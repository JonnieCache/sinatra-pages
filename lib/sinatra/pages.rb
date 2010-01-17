require 'sinatra/base'
require 'haml'

module Sinatra
  class Pages < Sinatra::Base
    %w[/? /:page /*/:page].each do |route|
      get route do
        params[:page] = 'home' if params[:page].nil?
        
        page_to_render = params[:splat].nil? ? '' : "#{params[:splat].first}/"
        page_to_render << params[:page]
        
        begin
          haml page_to_render.to_sym
        rescue Errno::ENOENT
          halt 404
        end
      end
    end
    
    not_found do
      params[:page] = 'not_found'
      
      haml :not_found
    end
  end
end