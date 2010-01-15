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
    it "should render the Home page if the given route is empty." do
      File.exist?('views/home.haml').should be_true
      
      get ''
      
      p last_response
      last_response.should be_ok
      last_response.body.chomp.should == 'Home'
    end
    
    it "should render the Home page if the given route is '/'." do
      File.exist?('views/home.haml').should be_true
      
      get '/'
      
      last_response.should be_ok
      last_response.body.chomp.should == 'Home'
    end
  end
  
  after :all do
    FileUtils.rm_r 'views', :force => true
  end
end