require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  include HelperMethods
  
  def app
    TestApp
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
  
  context 'HAML settings' do
    context 'by default' do
      subject {app}
      its(:html) {should == :v5}
      its(:format) {should == :tidy}
      its(:escaping) {should == false}
      its(:haml) {should == {:format => :html5, :ugly => false, :escape_html => false}}
    end
    
    context 'on defining' do
      before do
        app.set :html, :v5
        app.set :format, :tidy
        app.disable :escaping
      end
      
      [:v4, :vX].each do |value|
        context '#html' do
          subject {app.set :html, value}
          its(:html) {should == value}
          it {subject.haml[:format].should == (value == :v4 ? :html4 : :xhtml)}
        end
      end
      
      context '#format' do
        subject {app.set :format, :ugly}
        its(:format) {should == :ugly}
        it {subject.haml[:ugly].should == true}
      end
      
      context '#escaping' do
        #subject {app.enable :escaping}
        subject {app.set :escaping, true}
        its(:escaping) {should == true}
        it {subject.haml[:escape_html].should == true}
      end
    end
  end
  
  context 'on HTTP GET' do
    before :all do
      PAGES.each{|page| create_file_for(page, app.views)}
    end
    
    context 'in synchronous mode' do
      context 'with no Layout' do
        subject {File.join app.views, "#{file_of('Layout')}.haml"}
        it {File.exist?(subject).should == false}
        
        context 'and with Home static page' do
          subject {File.join app.views, "#{file_of('Home')}.haml"}
          it {File.exist?(subject).should == true}
          it 'should render it.' do
            ['/', ''].each do |route|
              get route

              last_request.should_not be_xhr
              last_response.should be_ok
              last_response.body.chomp.should == file_of('Home')
            end
          end
        end
        
        Dir.glob "#{Dir.pwd}/views/**/*.haml" do |file|
          filename = File.basename(file, '.haml').capitalize
          
          context "and with #{filename} static page" do
            subject {file}
            it {File.exist?(subject).should == true}
            it "should render it." do
              directory = File.dirname(subject)[5].nil? ? '' : File.dirname(subject)[5, File.dirname(subject).size]
              path = "#{directory}/#{File.basename(subject, '.haml')}"
              
              [path, "#{path}/"].each do |route|
                get route

                last_request.should_not be_xhr
                last_response.should be_ok
                last_response.body.chomp.should == File.basename(subject, '.haml')
              end
            end
          end
        end
        
        context 'and with a non-existing static page' do
          subject {File.join app.views, "#{file_of('Do Not Exist')}.haml"}
          it {File.exist?(subject).should == false}
          it 'should render the Not Found page.' do
            path = "/#{file_of('Do Not Exist')}"
            
            [path, "#{path}/"].each do |route|
              get route

              last_request.should_not be_xhr
              last_response.should be_not_found
              last_response.body.chomp.should == file_of('Not Found')
            end
          end
        end
      end
      
      context "with Layout" do
        before :all do
          create_file_for('Layout', app.views, ['Layout', '= yield'])
        end
        
        subject {File.join app.views, "#{file_of('Layout')}.haml"}
        it {File.exist?(subject).should == true}
        
        context 'and with Home static page' do
          subject {File.join app.views, "#{file_of('Home')}.haml"}
          it {File.exist?(subject).should == true}
          it 'should render both.' do
            ['/', ''].each do |route|
              get route

              last_request.should_not be_xhr
              last_response.should be_ok
              separate(last_response.body).first.should == 'Layout'
              separate(last_response.body).last.should == file_of('Home')
            end
          end
        end
        
        Dir.glob "#{Dir.pwd}/views/**/*.haml" do |file|
          filename = File.basename(file, '.haml').capitalize
          
          context "and with #{filename} static page" do
            subject {file}
            it {File.exist?(subject).should == true}
            it "should render both." do
              directory = File.dirname(subject)[5].nil? ? '' : File.dirname(subject)[5, File.dirname(subject).size]
              path = "#{directory}/#{File.basename(subject, '.haml')}"
              
              [path, "#{path}/"].each do |route|
                get route

                last_request.should_not be_xhr
                last_response.should be_ok
                separate(last_response.body).first.should == 'Layout'
                separate(last_response.body).last.should == File.basename(file, '.haml')
              end
            end
          end
        end

        context 'and with a non-existing static page' do
          subject {File.join app.views, "#{file_of('Do Not Exist')}.haml"}
          it {File.exist?(subject).should == false}
          it 'should render the Layout and the Not Found page.' do
            path = "/#{file_of('Do Not Exist')}"
            
            [path, "#{path}/"].each do |route|
              get route

              last_request.should_not be_xhr
              last_response.should be_not_found
              separate(last_response.body).first.should == 'Layout'
              separate(last_response.body).last.should == file_of('Not Found')
            end
          end
        end

        after :all do
          FileUtils.rm "#{app.views}/layout.haml"
        end
      end
    end
    
    context "in asynchronous mode" do
      context 'with no Layout' do
        subject {File.join app.views, "#{file_of('Layout')}.haml"}
        it {File.exist?(subject).should == false}
        
        context 'and with Home static page' do
          subject {File.join app.views, "#{file_of('Home')}.haml"}
          it {File.exist?(subject).should == true}
          it 'should render it.' do
            ['/', ''].each do |route|
              request route, :method => 'GET', :xhr => true

              last_request.should be_xhr
              last_response.should be_ok
              last_response.body.chomp.should == file_of('Home')
            end
          end
        end
        
        Dir.glob "#{Dir.pwd}/views/**/*.haml" do |file|
          filename = File.basename(file, '.haml').capitalize
          
          context "and with #{filename} static page" do
            subject {file}
            it {File.exist?(subject).should == true}
            it "should render it." do
              directory = File.dirname(subject)[5].nil? ? '' : File.dirname(subject)[5, File.dirname(subject).size]
              path = "#{directory}/#{File.basename(subject, '.haml')}"
              
              [path, "#{path}/"].each do |route|
                request route, :method => 'GET', :xhr => true

                last_request.should be_xhr
                last_response.should be_ok
                last_response.body.chomp.should == File.basename(subject, '.haml')
              end
            end
          end
        end
        
        context 'and with a non-existing static page' do
          subject {File.join app.views, "#{file_of('Do Not Exist')}.haml"}
          it {File.exist?(subject).should == false}
          it 'should render the Not Found page.' do
            path = "/#{file_of('Do Not Exist')}"
            
            [path, "#{path}/"].each do |route|
              request route, :method => 'GET', :xhr => true

              last_request.should be_xhr
              last_response.should be_not_found
              last_response.body.chomp.should == file_of('Not Found')
            end
          end
        end
      end
      
      context 'with a Layout' do
        before :all do
          create_file_for('Layout', app.views, ['Layout', '= yield'])
        end
        
        subject {File.join app.views, "#{file_of('Layout')}.haml"}
        it {File.exist?(subject).should == true}
        
        context 'and with Home static page' do
          subject {File.join app.views, "#{file_of('Home')}.haml"}
          it {File.exist?(subject).should == true}
          it 'should render it.' do
            ['/', ''].each do |route|
              request route, :method => 'GET', :xhr => true

              last_request.should be_xhr
              last_response.should be_ok
              last_response.body.chomp.should == file_of('Home')
            end
          end
        end
        
        Dir.glob "#{Dir.pwd}/views/**/*.haml" do |file|
          filename = File.basename(file, '.haml').capitalize
          
          context "and with #{filename} static page" do
            subject {file}
            it {File.exist?(subject).should == true}
            it "should render both." do
              directory = File.dirname(subject)[5].nil? ? '' : File.dirname(subject)[5, File.dirname(subject).size]
              path = "#{directory}/#{File.basename(subject, '.haml')}"
              
              [path, "#{path}/"].each do |route|
                request route, :method => 'GET', :xhr => true

                last_request.should be_xhr
                last_response.should be_ok
                last_response.body.chomp.should == File.basename(file, '.haml')
              end
            end
          end
        end

        context 'and with a non-existing static page' do
          subject {File.join app.views, "#{file_of('Do Not Exist')}.haml"}
          it {File.exist?(subject).should == false}
          it 'should render the Layout and the Not Found page.' do
            path = "/#{file_of('Do Not Exist')}"
            
            [path, "#{path}/"].each do |route|
              request route, :method => 'GET', :xhr => true

              last_request.should be_xhr
              last_response.should be_not_found
              last_response.body.chomp.should == file_of('Not Found')
            end
          end
        end

        after :all do
          FileUtils.rm "#{app.views}/layout.haml"
        end
      end
    end
    
    after :all do
      FileUtils.rm_r app.views, :force => true
    end
  end
end