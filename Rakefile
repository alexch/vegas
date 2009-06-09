require 'rake'
require 'rake/testtask'
require 'spec/rake/spectask'

require 'lib/db'

task :default => [:test, :spec]
Dir["lib/tasks/**/*.rake"].sort.each { |ext| load ext }
