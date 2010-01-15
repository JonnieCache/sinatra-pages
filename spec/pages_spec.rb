require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  
  def app
    Sinatra::Pages
  end

  before :all do
    FileUtils.mkdir 'views'
    File.open('views/home.haml', 'w'){|file| file << 'Home'}
    File.open('views/generic.haml', 'w'){|file| file << 'Generic'}
    File.open('views/generic_test.haml', 'w'){|file| file << 'Generic Test'}
    File.open('views/another_generic_test.haml', 'w'){|file| file << 'Another Generic Test'}
  end
  
  context "when using the HTTP GET request method" do
    it "should render the Home page if the given route is either empty or root." do
      File.exist?('views/home.haml').should be_true
      
      ['/', ''].each do |route|
        get route

        last_response.should be_ok
        last_response.body.chomp.should == 'Home'
      end
    end
    
    it "should render an existing page if the given route match the '/:page' pattern." do
      ['Generic', 'Generic Test', 'Another Generic Test'].each do |file|
        filename = file.downcase.gsub(' ', '_')
        
        File.exist?("views/#{filename}.haml").should be_true

        get "/#{filename}"
        
        last_response.should be_ok
        last_response.body.chomp.should == file
      end
    end
  end

  after :all do
    FileUtils.rm_r 'views', :force => true
  end
end