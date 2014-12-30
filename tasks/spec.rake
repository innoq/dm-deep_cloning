require 'spec/rake/spectask'

spec_defaults = lambda do |spec|
  spec.pattern    = 'spec/**/*_spec.rb'
  spec.libs      << 'lib' << 'spec'
  spec.spec_opts << '--options' << 'spec/spec.opts'
end

Spec::Rake::SpecTask.new(:spec, &spec_defaults)

task :default => :spec
