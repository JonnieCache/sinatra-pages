require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  
  def app
    Sinatra::Pages
  end

  PAGES = ['Home', 'Generic', 'Generic Test', 'Another Generic Test', 'Not Found']

  file_of = ->(page){page.downcase.gsub ' ', '_'}
  separate = ->(text){text.chomp.split("\n")}
  create_file_for = ->(page, content=[]) do 
    File.open("views/#{file_of.(page)}.haml", 'w') do |file| 
      content.empty? ? file << page : 
                       content.each{|line| file.puts line}
    end
  end
    
  before :all do
    FileUtils.mkdir 'views'
    PAGES.each{|page| create_file_for.(page)}
  end
  
  context "uses HTTP GET request method" do
    context "with no Layout file" do
      it "should render just the Home page if the given route is either empty or root." do
        File.exist?("views/#{file_of.('Home')}.haml").should be_true

        ['/', ''].each do |route|
          get route

          last_response.should be_ok
          last_response.body.chomp.should == 'Home'
        end
      end

      it "should render just an existing page if the given route match the '/:page' pattern." do
        PAGES.each do |page|
          File.exist?("views/#{file_of.(page)}.haml").should be_true

          get "/#{file_of.(page)}"

          last_response.should be_ok
          last_response.body.chomp.should == page
        end
      end

      it "should render just the Not Found page if a given route can't find its static page on 'views/'." do
        File.exist?("views/#{file_of.('Do Not Exist')}.haml").should be_false

        get "/#{file_of.('Do Not Exist')}"

        last_response.should be_not_found
        last_response.body.chomp.should == 'Not Found'
      end
    end
    
    context "with a Layout file" do
      before :all do
        create_file_for.('Layout', ['Layout', '= yield'])
      end
      
      it "should render both the Layout and Home page if the given route is either empty or root." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_true
        File.exist?("views/#{file_of.('Home')}.haml").should be_true

        ['/', ''].each do |route|
          get route

          last_response.should be_ok
          separate.(last_response.body).first.should == 'Layout'
          separate.(last_response.body).last.should == 'Home'
        end
      end

      it "should render both the Layout and an existing page if the given route match the '/:page' pattern." do
        PAGES.each do |page|
          File.exist?("views/#{file_of.('Layout')}.haml").should be_true
          File.exist?("views/#{file_of.(page)}.haml").should be_true

          get "/#{file_of.(page)}"

          last_response.should be_ok
          separate.(last_response.body).first.should == 'Layout'
          separate.(last_response.body).last.should == page
        end
      end

      it "should render both the Layout and the Not Found page if a given route can't find its static page on 'views/'." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_true
        File.exist?("views/#{file_of.('Do Not Exist')}.haml").should be_false

        get "/#{file_of.('Do Not Exist')}"

        last_response.should be_not_found
        separate.(last_response.body).first.should == 'Layout'
        separate.(last_response.body).last.should == 'Not Found'
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