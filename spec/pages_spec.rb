require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  include HelperMethods
  
  def app
    TestApp
  end

  before :all do
    PAGES.each{|page| create_file_for(page)}
  end
  
  context 'built-in settings' do
    context 'by default' do
      subject {app}
      its(:root) {should == Dir.pwd}
      its(:public) {should == File.join(Dir.pwd, 'public')}
      its(:views) {should == File.join(Dir.pwd, 'views')}
      its(:static) {should == true} 
    end

    context 'on defining' do
      before {app.set :root, Dir.pwd}
      
      context '#root' do
        subject {app.set :root, File.dirname(__FILE__)}
        its(:root) {should == File.dirname(__FILE__)}
        its(:public) {should == File.join(File.dirname(__FILE__), 'public')}
        its(:views) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:static) {should == true}
      end

      context '#public' do
        subject {app.set :public, File.join(File.dirname(__FILE__), 'public')}
        its(:root) {should == Dir.pwd}
        its(:public) {should == File.join(File.dirname(__FILE__), 'public')}
        its(:views) {should == File.join(Dir.pwd, 'views')}
        its(:static) {should == true}
      end

      context '#views' do
        subject {app.set :views, File.join(File.dirname(__FILE__), 'views')}
        its(:root) {should == Dir.pwd}
        its(:public) {should == File.join(Dir.pwd, 'public')}
        its(:views) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:static) {should == true}
      end
    end
  end
  
  context "on HTTP GET" do
    context "in synchronous mode" do
      context "with no Layout file" do
        it "should render only the Home page if the given route is either empty or root." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_false
          File.exist?("views/#{file_of('Home')}.haml").should be_true

          ['/', ''].each do |route|
            get route
            
            last_request.should_not be_xhr
            last_response.should be_ok
            last_response.body.chomp.should == file_of('Home')
          end
        end
        
        it "should render only an existing page if the given route match the '/:page' or '/*/:page' patterns." do
          Dir.glob 'views/**/*.haml' do |file|
            File.exist?("views/#{file_of('Layout')}.haml").should be_false
            File.exist?(file).should be_true

            directory = File.dirname(file)[5].nil? ? '' : File.dirname(file)[5, File.dirname(file).size]

            get "#{directory}/#{File.basename(file, '.haml')}"

            last_request.should_not be_xhr
            last_response.should be_ok
            last_response.body.chomp.should == File.basename(file, '.haml')
          end
        end
        
        it "should render only the Not Found page if a given route can't find its static page on 'views/'." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_false
          File.exist?("views/#{file_of('Do Not Exist')}.haml").should be_false

          get "/#{file_of('Do Not Exist')}"

          last_request.should_not be_xhr
          last_response.should be_not_found
          last_response.body.chomp.should == file_of('Not Found')
        end
      end
      
      context "with Layout file" do
        before :all do
          create_file_for('Layout', 'views', ['Layout', '= yield'])
        end

        it "should render both the Layout and Home page if the given route is either empty or root." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_true
          File.exist?("views/#{file_of('Home')}.haml").should be_true

          ['/', ''].each do |route|
            get route

            last_request.should_not be_xhr
            last_response.should be_ok
            separate(last_response.body).first.should == 'Layout'
            separate(last_response.body).last.should == file_of('Home')
          end
        end

        it "should render both the Layout and an existing page if the given route match the '/:page' or '/*/:page' patterns." do
          Dir.glob('views/**/*.haml').reject{|file| file =~ /layout/}.each do |file|
            File.exist?("views/#{file_of('Layout')}.haml").should be_true
            File.exist?(file).should be_true

            directory = File.dirname(file)[5].nil? ? '' : File.dirname(file)[5, File.dirname(file).size]

            get "#{directory}/#{File.basename(file, '.haml')}"

            last_request.should_not be_xhr
            last_response.should be_ok
            separate(last_response.body).first.should == 'Layout'
            separate(last_response.body).last.should == File.basename(file, '.haml')
          end
        end

        it "should render both the Layout and the Not Found page if a given route can't find its static page on 'views/'." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_true
          File.exist?("views/#{file_of('Do Not Exist')}.haml").should be_false

          get "/#{file_of('Do Not Exist')}"

          last_request.should_not be_xhr
          last_response.should be_not_found
          separate(last_response.body).first.should == 'Layout'
          separate(last_response.body).last.should == file_of('Not Found')
        end

        after :all do
          FileUtils.rm 'views/layout.haml'
        end
      end
    end
    
    context "in asynchronous mode" do
      context "with no Layout file" do
        it "should render just the Home page if the given route is either empty or root." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_false
          File.exist?("views/#{file_of('Home')}.haml").should be_true

          ['/', ''].each do |route|
            request route, :method => 'GET', :xhr => true

            last_request.should be_xhr
            last_response.should be_ok
            last_response.body.chomp.should == file_of('Home')
          end
        end
        
        it "should render just an existing page if the given route match the '/:page' or '/*/:page' patterns." do
          Dir.glob 'views/**/*.haml' do |file|
            File.exist?("views/#{file_of('Layout')}.haml").should be_false
            File.exist?(file).should be_true

            directory = File.dirname(file)[5].nil? ? '' : File.dirname(file)[5, File.dirname(file).size]

            request "#{directory}/#{File.basename(file, '.haml')}", :method => 'GET', :xhr => true

            last_request.should be_xhr
            last_response.should be_ok
            last_response.body.chomp.should == File.basename(file, '.haml')
          end
        end
        
        it "should render just the Not Found page if a given route can't find its static page on 'views/." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_false
          File.exist?("views/#{file_of('Do Not Exist')}.haml").should be_false

          request "/#{file_of('Do Not Exist')}", :method => 'GET', :xhr => true

          last_request.should be_xhr
          last_response.should be_not_found
          last_response.body.chomp.should == file_of('Not Found')
        end
      end
      
      context "with a Layout file" do
        before :all do
          create_file_for('Layout', 'views', ['Layout', '= yield'])
        end

        it "should render both the Layout and Home page if the given route is either empty or root." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_true
          File.exist?("views/#{file_of('Home')}.haml").should be_true

          ['/', ''].each do |route|
            request route, :method => 'GET', :xhr => true

            last_request.should be_xhr
            last_response.should be_ok
            last_response.body.chomp.should == file_of('Home')
          end
        end

        it "should render both the Layout and an existing page if the given route match the '/:page' or '/*/:page' patterns." do
          Dir.glob('views/**/*.haml').reject{|file| file =~ /layout/}.each do |file|
            File.exist?("views/#{file_of('Layout')}.haml").should be_true
            File.exist?(file).should be_true

            directory = File.dirname(file)[5].nil? ? '' : File.dirname(file)[5, File.dirname(file).size]

            request "#{directory}/#{File.basename(file, '.haml')}", :method => 'GET', :xhr => true

            last_request.should be_xhr
            last_response.should be_ok
            last_response.body.chomp.should == File.basename(file, '.haml')
          end
        end

        it "should render both the Layout and the Not Found page if a given route can't find its static page on 'views/'." do
          File.exist?("views/#{file_of('Layout')}.haml").should be_true
          File.exist?("views/#{file_of('Do Not Exist')}.haml").should be_false

          request "/#{file_of('Do Not Exist')}", :method => 'GET', :xhr => true

          last_request.should be_xhr
          last_response.should be_not_found
          last_response.body.chomp.should == file_of('Not Found')
        end

        after :all do
          FileUtils.rm 'views/layout.haml'
        end
      end
    end
  end

  after :all do
    FileUtils.rm_r 'views', :force => true
  end
end