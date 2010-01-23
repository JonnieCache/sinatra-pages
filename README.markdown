# Sinatra Pages
This is a [Sinatra Extension][1] that renders any page or sub-pages located under the directory defined as *:views* and the layout file defined as *:layout* (if there is any) inside your [Sinatra][2] application.

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
          |- a_file.haml
          |- another_file.haml
          |- another_file/yet_another_file.haml
          |- another_file/yet_another_file/still_another_file.haml
          |- ...more files and subdirectories...
          |- layout.haml
          |- not_found.haml

The only restriction is extension imposes is that you have to create the *home.haml* and the *not_found.haml* files inside the directory you defined as *:views* for the pluggable application (Sinatra uses the *views/* directory as the default path for the *:views* option). Then you're free to add any layout (Sinatra defined the *layout.haml* file as the default specification for the *:layout* option) and page under any file structure hierarchy inside this directory.

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