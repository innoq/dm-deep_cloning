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

require 'dm-deep_cloning'

require 'dm-core/spec/setup'
DataMapper::Spec.setup

require 'dm-migrations'
require 'dm-timestamps'

# classes/vars for tests
class Post
  include DataMapper::Resource

  property :id,     Serial
  property :type,   Discriminator

  property :author, String
  property :title,  String
  property :text,   Text

  timestamps :at
  
  belongs_to :blog
  has n, :comments
  has n, :related_posts, "Post", :through => Resource
end

class SpecialPost < Post
  property :secret, String
end

class Blog
  include DataMapper::Resource
  property :id,   Serial
  property :name, String

  has n, :posts
end

class Comment
  include DataMapper::Resource
  
  property :id, Serial
  property :author, String
  property :text, Text

  belongs_to :blog
end