require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  
  def app
    Sinatra::Pages
  end

  PAGES = ['Home','Generic',{'Generic Test'=>'Test'},{'Another Generic Test'=>{'Generic Test'=>'Test'}},'Not Found']

  file_of = ->(page){page.downcase.gsub ' ', '_'}
  separate = ->(text){text.chomp.split("\n")}
  create_file_for = ->(page, directory = 'views', content = []) do 
    page_to_create = page.class == String ? page : page.keys.first
    content << '= "#{params[:page]}"' if content.empty?
    
    Dir.mkdir directory unless File.exist? "#{directory}/"
    File.open("#{directory}/#{file_of.(page_to_create)}.haml", 'w'){|file| content.each{|line| file.puts line}}
    
    create_file_for.(page.values.first, "#{directory}/#{file_of.(page.keys.first)}") if page.class == Hash
  end
    
  before :all do
    FileUtils.mkdir 'views'
    PAGES.each{|page| create_file_for.(page)}
  end
  
  context "uses HTTP GET request method" do
    context "with no Layout file" do
      it "should render just the Home page if the given route is either empty or root." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_false
        File.exist?("views/#{file_of.('Home')}.haml").should be_true

        ['/', ''].each do |route|
          get route

          last_response.should be_ok
          last_response.body.chomp.should == file_of.('Home')
        end
      end

      it "should render just an existing page if the given route match the '/:page' or '/*/:page' patterns." do
        Dir.glob 'views/**/*.haml' do |file|
          directory = ''
          
          File.exist?("views/#{file_of.('Layout')}.haml").should be_false
          File.exist?(file).should be_true
          
          directory << File.dirname(file)[5, File.dirname(file).size] unless File.dirname(file)[5].nil?

          get "#{directory}/#{File.basename(file, '.haml')}"

          last_response.should be_ok
          last_response.body.chomp.should == File.basename(file, '.haml')
        end
      end

      it "should render just the Not Found page if a given route can't find its static page on 'views/'." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_false
        File.exist?("views/#{file_of.('Do Not Exist')}.haml").should be_false

        get "/#{file_of.('Do Not Exist')}"

        last_response.should be_not_found
        last_response.body.chomp.should == file_of.('Not Found')
      end
    end
    
    context "with a Layout file" do
      before :all do
        create_file_for.('Layout', 'views', ['Layout', '= yield'])
      end
      
      it "should render both the Layout and Home page if the given route is either empty or root." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_true
        File.exist?("views/#{file_of.('Home')}.haml").should be_true

        ['/', ''].each do |route|
          get route

          last_response.should be_ok
          separate.(last_response.body).first.should == 'Layout'
          separate.(last_response.body).last.should == file_of.('Home')
        end
      end

      it "should render both the Layout and an existing page if the given route match the '/:page' or '/*/:page' patterns." do
        Dir.glob('views/**/*.haml').reject{|file| file =~ /layout/}.each do |file|
          File.exist?("views/#{file_of.('Layout')}.haml").should be_true
          File.exist?(file).should be_true
          
          directory = File.dirname(file)[5].nil? ? '' : File.dirname(file)[5, File.dirname(file).size]
          
          get "#{directory}/#{File.basename(file, '.haml')}"

          last_response.should be_ok
          separate.(last_response.body).first.should == 'Layout'
          separate.(last_response.body).last.should == File.basename(file, '.haml')
        end
      end

      it "should render both the Layout and the Not Found page if a given route can't find its static page on 'views/'." do
        File.exist?("views/#{file_of.('Layout')}.haml").should be_true
        File.exist?("views/#{file_of.('Do Not Exist')}.haml").should be_false

        get "/#{file_of.('Do Not Exist')}"

        last_response.should be_not_found
        separate.(last_response.body).first.should == 'Layout'
        separate.(last_response.body).last.should == file_of.('Not Found')
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