require 'sinatra/base'
require 'haml'

module Sinatra
  class Pages < Sinatra::Base
    %w[/? /:page].each do |route|
      get route do
        params[:page] = 'home' if params[:page].nil?
        
        haml params[:page].to_sym
      end
    end
  end
end