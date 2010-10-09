require 'spec_helper'

describe Sinatra::Pages do
  include Rack::Test::Methods
  include HelperMethods
  
  def app
    TestApp
  end

  context 'Directories settings' do
    context 'by default' do
      subject {app}
      its(:root) {should == Dir.pwd}
      its(:public) {should == File.join(Dir.pwd, 'public')}
      its(:views) {should == File.join(Dir.pwd, 'views')}
      its(:pages) {should == File.join(Dir.pwd, 'views')}
      its(:static) {should == true} 
    end

    context 'on defining' do
      before {app.set :root, Dir.pwd}
      
      context '#root' do
        subject {app.set :root, File.dirname(__FILE__)}
        its(:root) {should == File.dirname(__FILE__)}
        its(:public) {should == File.join(File.dirname(__FILE__), 'public')}
        its(:views) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:pages) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:static) {should == true}
      end

      context '#public' do
        subject {app.set :public, File.join(File.dirname(__FILE__), 'public')}
        its(:root) {should == Dir.pwd}
        its(:public) {should == File.join(File.dirname(__FILE__), 'public')}
        its(:views) {should == File.join(Dir.pwd, 'views')}
        its(:pages) {should == File.join(Dir.pwd, 'views')}
        its(:static) {should == true}
      end

      context '#views' do
        subject {app.set :views, File.join(File.dirname(__FILE__), 'views')}
        its(:root) {should == Dir.pwd}
        its(:public) {should == File.join(File.dirname(__FILE__), 'public')}
        its(:views) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:pages) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:static) {should == true}
      end
      
      context '#pages' do
        subject {app.set :pages, File.join(app.views, 'pages')}
        its(:root) {should == Dir.pwd}
        its(:public) {should == File.join(File.dirname(__FILE__), 'public')}
        its(:views) {should == File.join(File.dirname(__FILE__), 'views')}
        its(:pages) {should == File.join(app.views, 'pages')}
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
      if RUBY_VERSION.to_f > 1.8
        its(:encoding) {should == :utf8}
        its(:haml) {should == {:format => :html5, :ugly => false, :escape_html => false, :encoding => 'utf-8'}}
      else
        its(:haml) {should == {:format => :html5, :ugly => false, :escape_html => false}}
      end
    end
    
    context 'on defining' do
      before do
        app.set :html, :v5
        app.set :format, :tidy
        app.disable :escaping
      end
      
      [:v4, :vX].each do |html|
        context '#html' do
          subject {app.set :html, html}
          its(:html) {should == html}
          it {subject.haml[:format].should == (html == :v4 ? :html4 : :xhtml)}
        end
      end
      
      [:tidy, :ugly].each do |format|
        context '#format' do
          subject {app.set :format, format}
          its(:format) {should == format}
          it {subject.haml[:ugly].should == (format == :ugly ? true : false)}
        end
      end
      
      [true, false].each do |escaping|
        context '#escaping' do
          #subject {app.enable :escaping}
          subject {app.set :escaping, escaping}
          its(:escaping) {should == escaping}
          it {subject.haml[:escape_html].should == escaping}
        end
      end
      
      if RUBY_VERSION.to_f > 1.8
        [:utf8, :utf16, :utf32, :ascii].each do |encoding|
          context '#encoding' do
            subject {app.set :encoding, encoding}
            its(:encoding) {should == encoding}
            case encoding
            when :utf8 then it {subject.haml[:encoding].should == 'utf-8'}
            when :utf16 then it {subject.haml[:encoding].should == 'utf-16'}
            when :utf32 then it {subject.haml[:encoding].should == 'utf-32'}
            when :ascii then it {subject.haml[:encoding].should == 'ascii-8bits'}
            end
          end
        end
      end
    end
  end
  
  context 'SASS settings' do
    context 'by default' do
      before {app.set :encoding, :utf8}
      subject {app}
      its(:stylesheet) {should == :scss}
      its(:format) {should == :tidy}
      its(:cache) {should == :write}
      if RUBY_VERSION.to_f > 1.8
        its(:encoding) {should == :utf8}
        its(:sass) {should == {:style => :expanded, :syntax => :scss, :cache => true, :encoding => 'utf-8'}}
      else
        its(:sass) {should == {:style => :expanded, :syntax => :scss, :cache => true}}
      end
    end
    
    context 'on defining' do
      before do
        app.set :stylesheet, :css
        app.set :format, :tidy
        app.set :cache, :write
      end
      
      [:css, :sass, :scss].each do |stylesheet|
        context '#stylesheet' do
          subject {app.set :stylesheet, stylesheet}
          its(:stylesheet) {should == stylesheet}
          it {subject.sass[:syntax].should == stylesheet}
        end
      end
      
      [:tidy, :ugly].each do |format|
        context '#format' do
          subject {app.set :format, format}
          its(:format) {should == format}
          format == :tidy ? it {subject.sass[:style].should == :expanded} :
                            it {subject.sass[:style].should == :compressed}
        end
      end
      
      [:write, :read].each do |cache|
        context '#cache' do
          subject {app.set :cache, cache}
          its(:cache) {should == cache}
          if cache == :write
            it {subject.sass[:cache].should == true}
            it {subject.sass[:read_cache].should == nil}
          else
            it {subject.sass[:cache].should == nil}
            it {subject.sass[:read_cache].should == true}
          end
        end
      end
      
      if RUBY_VERSION.to_f > 1.8
        [:utf8, :utf16, :utf32, :ascii].each do |encoding|
          context '#encoding' do
            subject {app.set :encoding, encoding}
            its(:encoding) {should == encoding}
            case encoding
            when :utf8 then it {subject.sass[:encoding].should == 'utf-8'}
            when :utf16 then it {subject.sass[:encoding].should == 'utf-16'}
            when :utf32 then it {subject.sass[:encoding].should == 'utf-32'}
            when :ascii then it {subject.sass[:encoding].should == 'ascii-8bits'}
            end
          end
        end
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