Gem::Specification.new do |s|
  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'
  s.rubygems_version = '1.3.7'
  s.name = 'sinatra-pages'
  s.version = '1.5.3'
  s.date = Time.now.strftime '%Y-%m-%d'
  s.authors = ['Julio Javier Cicchelli']
  s.email = 'javier@rock-n-code.com'
  s.homepage = 'http://github.com/rock-n-code/sinatra-pages'
  s.summary = 'A Sinatra extension for static pages rendering.'
  s.description = <<-DESCRIPTION
    A Sinatra extension for static pages rendering using the HAML rendering engine.
  DESCRIPTION
  s.add_runtime_dependency 'sinatra', '>= 1.0.0'
  s.add_runtime_dependency 'tilt', '>= 1.1.0'
  s.add_runtime_dependency 'haml', '~> 3.0'
  s.add_runtime_dependency 'sass', '~> 3.0'
  s.add_development_dependency 'rspec', '>= 1.3.0'
  s.add_development_dependency 'rack-test', '>= 0.5.6'
  s.files = %w[LICENSE README.markdown Rakefile] + Dir.glob('{lib,spec}/**/*')
  s.test_files = Dir.glob('spec/*.rb')
  s.has_rdoc = false
end