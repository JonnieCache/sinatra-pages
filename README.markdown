# Sinatra Pages
This is a [Sinatra Extension][1] that renders any page located under the *views/* directory inside your [Sinatra][2] application.

### Installation
In order to install this gem, you just need to install the gem from your command line like this:
  
  $sudo gem install sinatra-pages

You should take into account that this library have the following dependencies:

* [sinatra][2]
* [haml][3]

### Usage
Before plug in this extension, you should create the following file structure inside your application.

  app/
   |- config.ru
   |- views/
        |- home.haml
        |- layout.haml
        |- not_found.haml

Then, you just need to plug it in inside your *config.ru* file.

  require 'sinatra'
  require 'sinatra/pages'
  
  map '/' do
    run Sinatra::Pages
  end
  
Finally, you should test your application by executing the following command on your command line.

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
This library is being developed by using the [Ruby 1.9.1 interpreter][8] and was not being tested on any other version of the interpreter.

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