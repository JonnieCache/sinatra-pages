GEM = Gem::Specification.new do |specification|
  specification.required_ruby_version = '>= 1.8.6'
  specification.required_rubygems_version = '>= 1.3.5'
  specification.rubygems_version = '1.3.7'
  specification.name = 'sinatra-pages'
  specification.version = '1.5.2'
  specification.date = Time.now.strftime '%Y-%m-%d'
  specification.authors = ['Julio Javier Cicchelli']
  specification.email = 'javier@rock-n-code.com'
  specification.homepage = 'http://github.com/rock-n-code/sinatra-pages'
  specification.summary = 'A Sinatra extension for static pages rendering.'
  specification.description = <<-DESCRIPTION
    A Sinatra extension for static pages rendering using the HAML rendering engine.
  DESCRIPTION
  specification.add_runtime_dependency 'sinatra', '>= 1.0.0'
  specification.add_runtime_dependency 'tilt', '>= 1.1.0'
  specification.add_runtime_dependency 'haml', '>= 3.0.21'
  specification.add_development_dependency 'rspec', '>= 1.3.0'
  specification.add_development_dependency 'rack-test', '>= 0.5.6'
  specification.files = %w[LICENSE README.markdown Rakefile] + Dir.glob('{lib,spec}/**/*')
  specification.test_files = Dir.glob('spec/*.rb')
  specification.has_rdoc = false
end