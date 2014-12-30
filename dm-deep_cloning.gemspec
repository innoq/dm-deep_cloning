# -*- encoding: utf-8 -*-

require File.expand_path('../lib/data_mapper/deep_cloning/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "dm-deep_cloning"
  s.version = DataMapper::DeepCloning::VERSION 

  s.authors = ["Till Schulte-Coerne"]
  s.date = "2014-12-30"
  s.description = "A library that lets you clone objects and object graphs"
  s.summary = "A deep cloning extension for datamapper"  
  s.email = "till.schulte-coerne@innoq.com"
  s.homepage = "http://github.com/innoq/dm-deep_cloning"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.extra_rdoc_files = %w[LICENSE README.rdoc]  
  s.require_paths = ["lib"]

  s.add_dependency('dm-core', '~> 1.2')
  s.add_development_dependency('rake',  '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 1.3.2')
end

