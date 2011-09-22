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

require 'dm-core'
require 'dm-transactions'

module DataMapper
  module DeepCloning

    DEFAULT_MODE = :new

    def deep_clone(*args)
      mode = args.shift if [:new, :create].include?(args.first)
      mode ||= DEFAULT_MODE

      self.class.send(mode, self.attributes.reject{|(k, v)| self.class.properties[k].key? })
    end

  end # mod DeepCloning

  DataMapper::Resource.send(:include, DeepCloning)

end # mod DM
