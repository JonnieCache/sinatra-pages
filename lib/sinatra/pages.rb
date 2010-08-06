require 'sinatra/base'
require 'haml'
require 'sass'

module Sinatra
  module Pages
    def self.registered(app)
      app.set :html, :v5
      app.set :format, :tidy
      app.disable :escaping
      
      app.configure do
        app.set :root, Dir.pwd
        app.set :haml, Proc.new {setup(app)}
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

    private
    
    def setup(app)
      options = {:format => nil, :ugly => nil, :escape_html => nil}

      options[:ugly] = app.format == :ugly ? true : false
      options[:escape_html] = app.escaping
      options[:format] = case app.html
        when :v5 then :html5
        when :v4 then :html4
        when :vX then :xhtml
      end
      
      options
    end
  end
  
  register Pages
end