require 'rubygems' if RUBY_VERSION.to_f < 1.9
require 'rake/clean'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

CLEAN.include %w[cov/ pkg/]

desc 'Load the GemSpec definition file.'
load 'sinatra-pages.gemspec'

desc 'Package building.'
Rake::GemPackageTask.new GEM do |package|
  package.gem_spec = GEM
  package.need_tar = false
  package.need_zip = false
end

desc "Install the generated Gem into your system."
task :install => [:clean, :package] do
  sh "gem install pkg/*.gem --no-ri --no-rdoc"
end

namespace :deployment do 
  desc "Deployment on both Github and my own Server repository."
  task :repositories do
    sh 'git checkout master'
    sh 'git merge development'
    sh 'git push github master --tags'
    sh 'git push server master --tags'
    sh 'git checkout development'
  end
  
  desc "Deployment on Gemcutter."
  task :gemcutter => [:clean, :package] do
    sh "gem push pkg/*.gem"
  end
end

desc "Deployment on Github and Gemcutter."
task :deploy => ['deployment:repositories', 'deployment:gemcutter']

desc 'Functional testing with RSpec.'
Spec::Rake::SpecTask.new :spec do |task|
  task.spec_opts = %w[--colour --format progress --loadby mtime --timeout 20 --diff --backtrace]
  task.libs = %w[lib spec]
  task.spec_files = FileList['spec/**/*.rb']
  task.rcov = false
end

desc "Default is Functional testing with RSpec."
task :default => [:spec]