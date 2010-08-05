require 'sinatra/base'
require 'haml'

module Sinatra
  module Pages
    def self.registered(app)
      app.set :html, :v5
      app.set :format, :tidy
      app.disable :escaping
      
      app.configure do
        app.set :root, Dir.pwd
        app.enable :static
      end

      %w[/? /:page/? /*/:page/?].each do |route|
        app.get route do
          params[:page] = 'home' if params[:page].nil?

          page_to_render = params[:splat].nil? ? '' : "#{params[:splat].first}/"
          page_to_render << params[:page]

          begin
            haml page_to_render.to_sym, :layout => !request.xhr?
          rescue Errno::ENOENT
            halt 404
          end
        end
      end
      
      app.not_found do
        params[:page] = 'not_found'

        haml :not_found, :layout => !request.xhr?
      end
    end
  end
  
  register Pages
end