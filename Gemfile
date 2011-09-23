# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SOURCE         = ENV.fetch('SOURCE', :git).to_sym
REPO_POSTFIX   = SOURCE == :path ? ''                                : '.git'
DATAMAPPER     = SOURCE == :path ? Pathname(__FILE__).dirname.parent : 'http://github.com/datamapper'
DM_VERSION     = '~> 1.2.0.rc1'
DO_VERSION     = '~> 0.10.6'
DM_DO_ADAPTERS = %w[ sqlite postgres mysql oracle sqlserver ]

source 'http://rubygems.org'

gem 'dm-core',             :git => 'git://github.com/datamapper/dm-core.git'
gem 'dm-transactions',     :git => 'git://github.com/datamapper/dm-transactions.git'

group :development, :test do
  gem 'rake',                '~> 0.8.7'
  gem 'jeweler',             '~> 1.4'
  gem 'rspec',               '~> 1.3'

  group :datamapper do

    adapters = ENV['ADAPTER'] || ENV['ADAPTERS']
    adapters = adapters.to_s.tr(',', ' ').split.uniq - %w[ in_memory ]

    if (do_adapters = DM_DO_ADAPTERS & adapters).any?
      do_options = {}
      do_options[:git] = "#{DATAMAPPER}/do#{REPO_POSTFIX}" if ENV['DO_GIT'] == 'true'

      gem 'data_objects', DO_VERSION, do_options.dup

      do_adapters.each do |adapter|
        adapter = 'sqlite3' if adapter == 'sqlite'
        gem "do_#{adapter}", DO_VERSION, do_options.dup
      end

      gem 'dm-do-adapter', DM_VERSION, SOURCE => "#{DATAMAPPER}/dm-do-adapter#{REPO_POSTFIX}"
    end

    adapters.each do |adapter|
      gem 'ruby-oci8', :platform => :ruby if adapter == 'oracle'
      gem "dm-#{adapter}-adapter", DM_VERSION, SOURCE => "#{DATAMAPPER}/dm-#{adapter}-adapter#{REPO_POSTFIX}"
    end

    plugins = ENV['PLUGINS'] || ENV['PLUGIN']
    plugins = plugins.to_s.tr(',', ' ').split.push('dm-migrations').uniq

    plugins.each do |plugin|
      gem plugin, DM_VERSION, SOURCE => "#{DATAMAPPER}/#{plugin}#{REPO_POSTFIX}"
    end

  end

end

