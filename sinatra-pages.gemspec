GEM = Gem::Specification.new do |specification|
  specification.required_ruby_version = '>= 1.8.6'
  specification.required_rubygems_version = '>= 1.3.5'
  specification.rubygems_version = '1.3.5'
  specification.name = 'sinatra-pages'
  specification.version = '1.1.3'
  specification.date = Time.now.strftime '%Y-%m-%d'
  specification.authors = ['Julio Javier Cicchelli']
  specification.email = 'javier@rock-n-code.com'
  specification.homepage = 'http://github.com/rock-n-code/sinatra-pages'
  specification.summary = 'A Sinatra extension for static pages rendering.'
  specification.description = <<-DESCRIPTION
    A Sinatra extension for static pages rendering.
  DESCRIPTION
  specification.add_runtime_dependency 'sinatra', '>= 0.9.4'
  specification.add_runtime_dependency 'haml', '>= 2.2.20'
  specification.add_development_dependency 'rspec', '>= 1.3.0'
  specification.add_development_dependency 'rcov', '>= 0.9.8'
  specification.add_development_dependency 'rack-test', '>= 0.5.3'
  specification.files = %w[LICENSE README.markdown Rakefile] + Dir.glob('{lib,spec}/**/*')
  specification.test_files = Dir.glob('spec/*.rb')
  specification.has_rdoc = false
end