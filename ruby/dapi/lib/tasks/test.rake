
require 'rake/testtask'

Rake::TestTask.new do | t |
  t.libs.push "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

namespace :test do

  desc 'remove the test output files, such as code coverage'
  task :clean => :environment do
    delete_test_file 'coverage/index.html'
    delete_test_file 'coverage/.last_run.json'
    delete_test_file 'coverage/.resultset.json'
  end

  desc 'execute a test of the given f='
  task :file => :environment do
    ENV['TEST'] = ENV['f']
    Rake::Task["test"].execute
  end

end
