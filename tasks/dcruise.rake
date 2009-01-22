require 'dcruise/test_task'

namespace :cruise do
  DCruise::TestTask.new(:units) do |t|
    t.libs << "test"
    t.test_files = FileList['test/unit/**/*test.rb']
    t.verbose = true
  end
end