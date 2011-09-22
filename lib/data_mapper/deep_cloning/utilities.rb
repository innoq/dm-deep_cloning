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
    module Utilities
      module Hash

        def self.recursive_merge!(h1, h2)
          h1.merge!(h2) do |key, _old, _new|
            if _old.class == Hash
              recursive_merge!(_old, _new)
            else
              _new
            end
          end
        end

      end
    end
  end
end