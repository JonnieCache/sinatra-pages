GEM = Gem::Specification.new do |specification|
  specification.required_ruby_version = '>= 1.9.1'
  specification.required_rubygems_version = '>= 1.3.5'
  specification.rubygems_version = '1.3.5'
  specification.name = 'sinatra-pages'
  specification.version = '0.1.0'
  specification.date = '2010-01-15'
  specification.authors = ['Julio Javier Cicchelli']
  specification.email = 'javier@rock-n-code.com'
  specification.homepage = 'http://github.com/rock-n-code/sinatra-pages'
  specification.summary = 'A Sinatra extension to manage static pages.'
  specification.description = <<-DESCRIPTION
    A Sinatra extension to manage static pages.
  DESCRIPTION
  specification.add_runtime_dependency 'sinatra', '>= 0.9.4'
  specification.add_runtime_dependency 'haml', '>= 2.2.17'
  specification.add_development_dependency 'rspec', '>= 1.3.0'
  specification.add_development_dependency 'rcov', '>= 0.9.7.1'
  specification.add_development_dependency 'rake-test', '>= 0.5.3'
  specification.require_paths = 'lib'
  specification.files = %w(LICENSE README Rakefile) + Dir.glob('{lib,spec}/**/*')
  specification.test_files = Dir.glob('spec/*.rb')
  specification.has_rdoc = true
  specification.extra_rdoc_files = %w(README LICENSE)
  specification.rdoc_options = %w[--title Sinatra-Pages --main README --line-numbers --inline-source --charset=UTF-8]
end