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

      app.set :pages, Proc.new {app.views}
      app.set :styles, Proc.new {find_styles_directory app.public}
      app.set :html, :v5
      app.set :stylesheet, :scss
      app.set :cache, :write
      app.set :format, :tidy
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

      %w[/? /:page/? /*/:page/?].each do |route|
        app.get route do
          params[:page] = 'home' if params[:page].nil?

          page_to_render = settings.views != settings.pages ? "#{settings.pages.split('/').last}/" : ''
          page_to_render << "#{params[:splat].first}/" unless params[:splat].nil?
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
  end
  
  register Pages
end