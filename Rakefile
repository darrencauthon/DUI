require "bundler/gem_tasks"
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['spec/DUI/*_spec.rb', 'test/DUI/test_*.rb']
  t.verbose = true
end
