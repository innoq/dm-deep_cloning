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

SOURCE         = ENV.fetch('SOURCE', :rubygems).to_sym

DM_VERSION     = '~> 1.2'

DO_VERSION     = '~> 0.10.6'
DM_DO_ADAPTERS = %w[ sqlite postgres mysql oracle sqlserver ]

def dm(module_name)
  if SOURCE == :git
    gem "dm-#{module_name}", DM_VERSION, :git => "http://github.com/datamapper/dm-#{module_name}.git", :branch => ENV.fetch('BRANCH', 'master')
  elsif SOURCE == :path
    gem "dm-#{module_name}", DM_VERSION, :path => Pathname(__FILE__).dirname.parent
  else
    gem "dm-#{module_name}", DM_VERSION
  end
end

source 'https://rubygems.org'

dm('core')
dm('transactions')

group :development, :test do
  gem 'rake'
  gem 'rspec',             '~> 1.3'

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

      dm('do-adapter')
    end

    adapters.each do |adapter|
      gem 'ruby-oci8', :platform => :ruby if adapter == 'oracle'
      dm("#{adapter}-adapter")
    end

    plugins = ENV['PLUGINS'] || ENV['PLUGIN']
    plugins = plugins.to_s.tr(',', ' ').split.push('migrations', 'timestamps').uniq

    plugins.each do |plugin|
      dm(plugin.gsub(/^dm-/, ""))
    end

  end

end

