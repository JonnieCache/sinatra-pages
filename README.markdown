# Sinatra Pages
This is a [Sinatra][1] extension that renders any static page (including sub-pages) located under your *:pages* directory  using [HAML][2] and [SASS][3] as the rendering engines for HTML and stylesheets. By combining the main driving principles behind these two libraries, this extension allows you to build static websites for [Sinatra][2] or directly on [Rack][4] in no time.

### Installation
In order to install this gem, you just need to install the gem from your command line like this:
  
    $sudo gem install sinatra-pages

You should take into account that this library have the following dependencies:

* [sinatra][1]
* [tilt][12]
* [haml][2]
* [sass][3]

### Usage
Before using this extension, you should create the following file structure inside your application.

    app/
     |- app.rb
     |- config.ru
     |- public/
          |- images/
              |- ...
          |- scripts/
              |- ...
          |- styles/
              |- ...
     |- views/
          |- layout.haml
          |- not_found.haml
          |- pages/
                |- home.haml
                |- a_file.haml
                |- another_file.haml
                |- ...
                |- another_file/
                        |- yet_another_file.haml
                        |- ...
                        |- yet_another_file/
                                  |- still_another_file.haml
                                  |- ...

Please notice that this extension requires you to create the *layout.haml* (if required) and other common pages inside your *:views* directory on your application. Then you're free to add the static pages you need under any file structure hierarchy inside the *:pages* directory. Please don't forget to give the extension *.haml* to all your views.

Now, as any other existing extension, there are two possible use cases depending the kind of Sinatra application you're developing. If you follow the __Classic__ approach, then you just need to require this extension in the *app.rb* file.

    require 'sinatra'
    require 'sinatra/pages'
    
Then you should require your *app.rb* file inside the *config.ru* file in order to make your application runnable.

    require 'app'
    
    disable :run
    
    run Sinatra::Application

You can test your application by executing the following command on your command line.

    $app/ruby app.rb
    
In case you would prefer to follow the __Modular__ approach on your application design, then you just need to declare your application as a class that inherit from the *Sinatra::Base* class and then register the extension inside it in the *app.rb* file.

    require 'sinatra/base'
    require 'sinatra/pages'
    
    class App < Sinatra::Base
      register Sinatra::Pages
    end

Then you should require your *app.rb* inside the *config.ru* file and associate your application class to a certain route.

    require 'app'
    
    map '/' do
      run Sinatra::App
    end

You can try your modular application by executing the following command in your command line.

    $app/rackup config.ru
  
In order to verify if you application is working, open your web browser with the address that will appear after the execution described above.

### Built-in variables
This extension defines the following setup as default. In any case, you are able to change these values as required.

* __:public__ => <*Path to your public directory*> || **settings.root/public**
* __:views__ => <*Path to your views directory*> || **settings.root/views**
* __:pages__ => <*Path to your pages directory*> || **settings.root/views**
* __:html__ => [*:v4*, *:vX*, *:v5*] || **:v5**
* __:stylesheet__ => [*:css*, *:sass*, *:scss*] || **:scss**
* __:format__ => [*:tidy*, *:ugly*] || **:tidy**
* __:cache__ => [*:write*, *:read*] || **:write**
* __:encoding__ => [*:ascii*, *:utf8*, *:utf16*, *:utf32*] || **:utf8**
* __:escaping__ => [*true*, *false*] || **:false**

### Customization
Depending on the kind of Sinatra application you're developing, you should proceed as follows. If you follow the __Classic__ approach, then you just need to set these configuration parameters in the *app.rb* file.

    require 'sinatra'
    require 'sinatra/pages'
    
    set :views, File.join(Dir.pwd, 'templates')
    set :public, Proc.new {File.join(root, 'static')}
    
In case you would prefer to follow the __Modular__ approach on your application design, then you can set these variables  within your application as a class that inherit from the *Sinatra::Base* class in the *app.rb* file.

    require 'sinatra/base'
    require 'sinatra/pages'
    
    class App < Sinatra::Base
      register Sinatra::Pages
      
      set :views, File.join(Dir.pwd, 'templates')
      set :public, Proc.new {File.join(root, 'static')}
    end

Alternatively, you can also set these variables directly from the *config.ru* file in which your application class will be associated to a certain route.

    require 'app'
    
    map '/' do
      Sinatra::App.set :views, File.join(Dir.pwd, 'templates')
      Sinatra::App.set :public, Proc.new {File.join(root, 'static')}
      
      run Sinatra::App
    end

In order to verify if the customized setup is working as expected, open your web browser with the address that will appear after the execution described above.

### Contributions
Everybody is welcome to contribute to this project by commenting the source code, suggesting modifications or new ideas, reporting bugs, writing some documentation and, of course, you're also welcome to contribute with patches as well!

In case you would like to contribute on this library, here's the list of extra dependencies you would need:

* [rspec][5]
* [rack-test][6]

### Contributors
* [Julio Javier Cicchelli][7]

### Sites
The following sites are proudly using this extension:

* [Rock & Code][10]
* [Izcheznali][11]
* [Amsterdam Ruby User Group][13]

If your site is also using this extension, please let us know!

### Notes
This extension have been tested on [MRI][8] 1.8.6, 1.8.7, 1.9.1 and 1.9.2.

### License
This extension is licensed under the [MIT License][9].

[1]: http://www.sinatrarb.com/
[2]: http://haml-lang.com/
[3]: http://sass-lang.com/
[4]: http://rack.rubyforge.org/
[5]: http://rspec.info/
[6]: http://gitrdoc.com/brynary/rack-test/tree/master
[7]: http://github.com/mr-rock
[8]: http://www.ruby-lang.org/en/
[9]: http://creativecommons.org/licenses/MIT/
[10]: http://rock-n-code.com
[11]: http://izcheznali.net
[12]: http://github.com/rtomayko/tilt
[13]: http://amsterdam-rb.org