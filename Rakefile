require 'rubygems' if RUBY_VERSION.to_f < 1.9
require 'rake/clean'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

CLEAN.include %w[coverage/ pkg/]

desc 'Load the GemSpec definition file.'
load 'sinatra-pages.gemspec'

desc 'Package building.'
Rake::GemPackageTask.new(GEM) do |package|
  package.gem_spec = GEM
  package.need_tar = false
  package.need_zip = false
end

desc 'Functional testing with RSpec.'
Spec::Rake::SpecTask.new :spec do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.libs = %w[lib spec]
  task.spec_files = FileList['spec/**/*.rb']
  task.rcov = false
end

Spec::Rake::SpecTask.new(:rcov) do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.libs = %w[lib spec]
  task.spec_files = FileList['spec/*_spec.rb']
  task.rcov = true
  task.rcov_opts = IO.readlines('spec/opts/rcov.opts').each{|line| line.chomp!}
end