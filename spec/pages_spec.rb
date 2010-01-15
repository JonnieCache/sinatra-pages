require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  
  def app
    Sinatra::Pages
  end

  PAGES = ['Home', 'Generic', 'Generic Test', 'Another Generic Test', 'Not Found']

  file_of = ->(page){page.downcase.gsub ' ', '_'}
  create_file_for = ->(page){File.open("views/#{file_of.(page)}.haml", 'w'){|file| file << page}}

  before :all do
    FileUtils.mkdir 'views'
    PAGES.each{|page| create_file_for.(page)}
  end
  
  context "when using the HTTP GET request method" do
    context "and there is a Layout file" do
      before :all do
        File.open('views/layout.haml', 'w'){|file| file.puts 'Layout'; file.puts '= yield'}
      end
      
      it "should render the Layout and Home page if the given route is either empty or root." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_true
        File.exist?("views/#{file_of.('Home')}.haml").should be_true

        ['/', ''].each do |route|
          get route

          last_response.should be_ok
          last_response.body.chomp.split("\n").first.should == 'Layout'
          last_response.body.chomp.split("\n").last.should == 'Home'
        end
      end

      it "should render the Layout and an existing page if the given route match the '/:page' pattern." do
        PAGES.each do |page|
          File.exist?("views/#{file_of.('Layout')}.haml").should be_true
          File.exist?("views/#{file_of.(page)}.haml").should be_true

          get "/#{file_of.(page)}"

          last_response.should be_ok
          last_response.body.chomp.split("\n").first.should == 'Layout'
          last_response.body.chomp.split("\n").last.should == page
        end
      end

      it "should render the Layout and the Not Found page if a given route can't find its static page on 'views/'." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_true
        File.exist?("views/#{file_of.('Do Not Exist')}.haml").should be_false

        get "/#{file_of.('Do Not Exist')}"

        last_response.should be_not_found
        last_response.body.chomp.split("\n").first.should == 'Layout'
        last_response.body.chomp.split("\n").last.should == 'Not Found'
      end
      
      after :all do
        FileUtils.rm 'views/layout.haml'
      end
    end
  end

  after :all do
    FileUtils.rm_r 'views', :force => true
  end
end