require 'rake'

begin

  require 'jeweler'

  FileList['tasks/**/*.rake'].each { |task| load task }

  Jeweler::Tasks.new do |gem|

    gem.name        = "dm-deep_cloning"
    gem.summary     = %Q{A deep cloning extension for datamapper}
    gem.description = %Q{A library that lets you clone objects and object graphs}
    gem.email       = "till.schulte-coerne@innoq.com"
    gem.homepage    = "http://github.com/innoq/dm-deep_cloning"
    gem.authors     = ["Till Schulte-Coerne"]

    gem.add_dependency 'dm-core',           '~> 1.0'
    gem.add_dependency 'dm-transactions',     '~> 1.0'

    gem.add_development_dependency 'rspec', '~> 1.2.9'
    gem.add_development_dependency 'dm-migrations', '~> 1.2.9'

  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :default => :spec
