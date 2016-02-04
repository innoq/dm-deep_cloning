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

      attrs = self.attributes.reject{ |(k, v)|
        self.class.properties[k].key? || k.to_s =~ /^(updated|created)_(at|on)$/
      }

      clone_relations.keys.each do |relationship_name|
        relationship = self.class.relationships[relationship_name]

        case relationship
        when DataMapper::Associations::OneToMany::Relationship, DataMapper::Associations::ManyToMany::Relationship
          attrs[relationship.name] = self.send(relationship.name).to_a.map do |related_object|
            # Q: Why `to_a`????
            # A: This is used to indirectly disable `eager_load` in the `attributes` method called in the following recursive call.
            # Q: Aha!!! But why???
            # A: It simply doesn't work with STI.
            # Q: f***!
            # A: Yea! Took me 3 hours.
            related_object.deep_clone(mode, clone_relations[relationship.name])
          end
          if attrs[relationship.name].empty?
            # Delete the atrribute if no objects need to be assigned to the relation.
            # dm-core seems to have a problem with Foo.new(:bars => []). Sadly
            # this was not reproduceable in the specs.
            attrs.delete(relationship.name)
          end
        when DataMapper::Associations::ManyToOne::Relationship
          attrs[relationship.name] = self.send(relationship.name).deep_clone(mode, clone_relations[relationship.name])
        else
          raise "Deep cloning failed: Unknown relationship '#{relationship_name}' in '#{self.class}'"
        end
      end

      if DataMapper.const_defined?(:Is) && DataMapper::Is.const_defined?(:List) && self.class.is_a?(DataMapper::Is::List)
        attrs.delete(:position) # Pre-Setting positions doesn't work in DM::Is::List
      end

      self.class.send(mode, attrs)
    end

  end # mod DeepCloning

  DataMapper::Resource.send(:include, DeepCloning)

end # mod DM
