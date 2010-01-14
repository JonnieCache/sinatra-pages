require 'spec/rake/spectask'

desc 'Functional testing with RSpec.'
Spec::Rake::SpecTask.new :spec do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.spec_files = FileList['spec/**/*.rb']
  task.rcov = false
end

Spec::Rake::SpecTask.new(:rcov) do |task|
  task.spec_opts = %w[--options spec/opts/spec.opts]
  task.spec_files = FileList['spec/*_spec.rb']
  task.rcov = true
  task.rcov_opts = IO.readlines('spec/opts/rcov.opts').each{|line| line.chomp!}
end