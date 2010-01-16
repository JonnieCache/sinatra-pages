require 'rubygems' if RUBY_VERSION.to_f < 1.9
require 'rake/clean'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

CLEAN.include %w[coverage/ pkg/]

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
  sh 'gem19 install pkg/*.gem --no-ri --no-rdoc'
end

namespace :deployment do 
  desc "Deployment on both Github and my own Server repository."
  task :repositories do
    sh 'git checkout master'
    sh 'git merge development'
    sh 'git push rock-n-code master --tags'
    sh 'git push server master --tags'
    sh 'git checkout development'
  end
  
  desc "Deployment on Gemcutter."
  task :gemcutter => [:clean, :package] do
    sh 'gem19 push pkg/*.gem'
  end
end

desc "Deployment on Github and Gemcutter."
task :deploy => ['deployment:github', 'deployment:gemcutter']

desc 'Functional testing with RSpec.'
Spec::Rake::SpecTask.new :spec do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.libs = %w[lib spec]
  task.spec_files = FileList['spec/**/*.rb']
  task.rcov = false
end

desc 'Functional testing with RSpec and RCov.'
Spec::Rake::SpecTask.new :rcov do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.libs = %w[lib spec]
  task.spec_files = FileList['spec/*_spec.rb']
  task.rcov = true
  task.rcov_opts = IO.readlines('spec/opts/rcov.opts').each{|line| line.chomp!}
end

desc "Default is Functional testing with RSpec."
task :default => [:spec]