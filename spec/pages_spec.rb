require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  
  def app
    Sinatra::Pages
  end

  before :all do
    FileUtils.mkdir 'views'
    File.open('views/home.haml', 'w'){|file| file << 'Home'}
  end
  
  context "when using the HTTP GET request method" do
    it "should render the Home page if the given route is either empty or root." do
      File.exist?('views/home.haml').should be_true
      
      %w[/ /?].each do |route|
        get route

        last_response.should be_ok
        last_response.body.chomp.should == 'Home'
      end
    end
  end

  after :all do
    FileUtils.rm_r 'views', :force => true
  end
end