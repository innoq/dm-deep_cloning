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
require 'data_mapper/deep_cloning/utilities'

module DataMapper
  module DeepCloning

    DEFAULT_MODE = :new

    def deep_clone(*args)
      args_size = args.size # For error messages

      mode = args.shift if [:new, :create].include?(args.first)
      mode ||= DEFAULT_MODE

      clone_relations = {}
      args.each do |arg|
        case arg
        when Hash
          Utilities::Hash.recursive_merge!(clone_relations, arg)
        when Array
          arg.each do |el|
            clone_relations[el] = {}
          end
        when Symbol
          clone_relations[arg] = {}
        else
          raise ArgumentError, "deep_clone only accepts Symbols, Hashes or Arrays"
        end
      end
  
      attributes = self.attributes.reject{ |(k, v)|
        self.class.properties[k].key? || k.to_s =~ /^(updated|created)_(at|on)$/
      }

      clone_relations.keys.each do |relationship_name|
        relationship = self.class.relationships[relationship_name]

        case relationship
        when DataMapper::Associations::OneToMany::Relationship, DataMapper::Associations::ManyToMany::Relationship
          attributes[relationship.name] = self.send(relationship.name).map do |related_object|
            related_object.deep_clone(mode, clone_relations[relationship.name])
          end
          if attributes[relationship.name].empty?
            # Delete the atrribute if no objects need to be assigned to the relation.
            # dm-core seems to have a problem with Foo.new(:bars => []). Sadly
            # this was not reproduceable in the specs.
            attributes.delete(relationship.name)
          end
        when DataMapper::Associations::ManyToOne::Relationship
          attributes[relationship.name] = self.send(relationship.name).deep_clone(mode, clone_relations[relationship.name])
        else
          raise "Deep cloning failed: Unknown relationship '#{relationship.class}' for relation '#{relationship.name}' in '#{self.class}'"
        end
      end

      self.class.send(mode, attributes)
    end

  end # mod DeepCloning

  DataMapper::Resource.send(:include, DeepCloning)

end # mod DM
