require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  it "does something" do
    pending
  end
end