require 'sinatra/base'
require 'haml'
require 'sass'

module Sinatra
  module Pages
    def self.registered(app)
      app.set :html, :v5
      app.set :stylesheet, :css
      app.set :format, :tidy
      app.set :cache, :write
      app.disable :escaping
      
      app.configure do
        app.set :root, Dir.pwd
        app.set :haml, Proc.new {setup :haml, app}
        app.set :sass, Proc.new {setup :sass, app}
        app.set :styles, Proc.new {find_styles_directory public}
        app.enable :static
      end
      
      app.get '/*.css' do
        content_type :css, :charset => 'utf-8'
        
        sass File.basename(params[:splat].first).to_sym, :views => settings.styles
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
    
    def setup(type, settings)
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