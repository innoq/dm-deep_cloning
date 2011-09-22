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

require 'spec_helper'

describe DataMapper::DeepCloning do

  before(:all) do
    DataMapper.auto_migrate!
  end

  describe "non recursive cloning" do

    before(:all) do
      @post = Post.create(:title => 'First post', :text => "Sun is shining...", :blog => Blog.create(:name => 'Test Blog'))
    end

    it "should clone single objects unsaved" do
      @cloned_post = @post.deep_clone()

      @cloned_post.title.should == @post.title
      @cloned_post.id.should == nil
      @cloned_post.saved?.should == false

      @cloned_post.save.should == true
      @cloned_post.id.should_not be(@post.id)

      @cloned_post.blog.id.should be(@post.blog.id)
    end

    it "should clone single objects saved" do
      @cloned_post = @post.deep_clone(:create)

      @cloned_post.title.should == @post.title
      @cloned_post.saved?.should == true
      @cloned_post.id.should_not be(@post.id)

      @cloned_post.blog.id.should be(@post.blog.id)
    end
  end


end
