# Sinatra Pages
This is a [Sinatra Extension][1] that renders for browser and AJAX calls any page or sub-pages located under the directory defined as *:views* and the layout file defined as *:layout* (if there is any) inside your [Sinatra][2] application.

### Installation
In order to install this gem, you just need to install the gem from your command line like this:
  
    $sudo gem install sinatra-pages

You should take into account that this library have the following dependencies:

* [sinatra][2]
* [haml][3]

### Usage
Before using this extension, you should create the following file structure inside your application.

    app/
     |- app.rb
     |- config.ru
     |- views/
          |- home.haml
          |- a_file.haml
          |- another_file.haml
          |- another_file/yet_another_file.haml
          |- another_file/yet_another_file/still_another_file.haml
          |- ...more files and subdirectories...
          |- layout.haml
          |- not_found.haml

Please notice that this extension requires you to create the *home.haml* and the *not_found.haml* files inside the directory you defined as *:views* on your application (Sinatra uses the *views/* directory as the default path for the *:views* directory). Then you're free to add any layout (Sinatra defined the *layout.haml* file as the default specification for the *:layout* template) and page under any file structure hierarchy inside this directory.

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
    
    module Sinatra
      module App < Sinatra::Base
        register Sinatra::Pages
      end
    end

Then you should require your *app.rb* inside the *config.ru* file and associate your application class to a certain route.

    require 'app'
    
    disable :run
    
    map '/' do
      run Sinatra::App
    end

You can try your modular application by executing the following command in your command line.

    $app/rackup config.ru
  
In order to verify if you application is working, open your web browser with the address that will appear after the execution described above.
  
### Contributions
Everybody is welcome to contribute to this project by commenting the source code, suggesting modifications or new ideas, reporting bugs, writing some documentation and, of course, you're also welcome to contribute with patches as well!

In case you would like to contribute on this library, here's the list of extra dependencies you would need:

* [rspec][4]
* [rcov][5]
* [rack-test][6]

### Contributors
* [Julio Javier Cicchelli][7]

### Notes
This library is being developed by using the [Ruby 1.9.1 interpreter][8] and was not being tested on any other version of the interpreter nor any other implementation.

### License
This extension is licensed under the [MIT License][9].

[1]: http://www.sinatrarb.com/extensions.html
[2]: http://www.sinatrarb.com/
[3]: http://haml-lang.com/
[4]: http://rspec.info/
[5]: http://eigenclass.org/hiki/rcov
[6]: http://gitrdoc.com/brynary/rack-test/tree/master
[7]: http://github.com/mr-rock
[8]: http://www.ruby-lang.org/en/
[9]: http://creativecommons.org/licenses/MIT/