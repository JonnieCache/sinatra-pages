require 'sinatra/base'
require 'haml'
require 'sass'

module Sinatra
  module Pages
  
    def self.registered(app)
      app.configure do
        app.set :root, Dir.pwd
        app.enable :static
      end
      
      app.helpers Helpers

      app.set :pages, Proc.new {app.views}
      app.set :styles, Proc.new {find_styles_directory app.public}
      app.set :html, :v5
      app.set :stylesheet, :scss
      app.set :cache, :write
      app.set :format, :tidy
      app.set :encoding, :utf8 if RUBY_VERSION.to_f > 1.8
      app.disable :escaping
      
      app.configure do
        app.set :haml, Proc.new {generate_setup :haml, app}
        app.set :sass, Proc.new {generate_setup :sass, app}
      end
      
      app.condition {app.stylesheet != :css}
      app.get '/*.css' do
        content_type :css, :charset => 'utf-8'

        sass File.basename(params[:splat].first).to_sym, :views => settings.styles
      end

      %w[/? /:page.:format /*/:page.:format /:page/? /*/:page/?].each do |route|
        app.get route do
          params[:page] = 'home' if params[:page].nil?

          page_to_render = settings.views != settings.pages ? "#{settings.pages.split('/').last}/" : ''
          page_to_render << "#{params[:splat].first}/" unless params[:splat].nil?
          page_to_render << params[:page]
          
          begin
            haml page_to_render.to_sym, :layout => get_layout(page_to_render, request.xhr?)
          rescue Errno::ENOENT => e
            halt 404
          end
        end
      end
      
      app.not_found do
        params[:page] = 'not_found'
        haml :not_found, :layout => get_layout(:not_found, request.xhr?)
      end
      

    end

    private
    
    def generate_setup(type, settings)
      options = {}
      
      case type
        when :haml
          options[:ugly] = settings.format == :ugly ? true : false
          options[:escape_html] = settings.escaping
          options[:format] = case settings.html
            when :v5 then :html5
            when :v4 then :html4
            when :vX then :xhtml
          end
        when :sass
          options[:style] = settings.format == :tidy ? :expanded : :compressed
          options[:syntax] = settings.stylesheet
          options[:cache] = true if settings.cache == :write
          options[:read_cache] = true if settings.cache == :read
      end
      
      if RUBY_VERSION.to_f > 1.8
        options[:encoding] = case settings.encoding
          when :utf8 then 'utf-8'
          when :utf16 then 'utf-16'
          when :utf32 then 'utf-32'
          when :ascii then 'ascii-8bits'
        end
      end
      
      options
    end
    
    def find_styles_directory(public_directory)
      %w[*.css *.scss *.sass].each do |extension|
        files = Dir.glob File.join(public_directory, '**', extension)

        return File.dirname(files.first) unless files.empty? 
      end

      %w[css styles stylesheets].each do |directory| 
        directory = File.join public_directory, directory

        return directory if File.exist?(directory)
      end

      nil
    end
    
    module Helpers
      def get_layout(page, xhr)
        if xhr
          ret = false
        elsif File.exist? File.join(settings.views, "#{page}_layout.haml")
          ret = "#{page}_layout".to_sym
        elsif File.exist? File.join(settings.views, "layout.haml")
          ret = :layout
        else
          ret = false
        end
        return ret
      end
    end
      
  end
  
  register Pages
end
