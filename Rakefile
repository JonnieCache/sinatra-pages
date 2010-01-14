require 'spec/rake/spectask'

desc 'Functional testing with RSpec.'
Spec::Rake::SpecTask.new :spec do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.spec_files = FileList['spec/**/*.rb']
  task.rcov = false
end