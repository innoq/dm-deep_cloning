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
      @blog = Blog.create(:name => 'Test Blog')
      @post1 = Post.create(:title => 'First post', :text => "Sun is shining...", :blog => @blog)
      @post2 = Post.create(:title => 'Second post', :text => "Now the moon is shining", :blog => @blog, :related_posts => [@post1])
    end

    it "should clone single objects unsaved" do
      cloned_post = @post1.deep_clone()

      cloned_post.title.should == @post1.title
      cloned_post.id.should be_nil
      cloned_post.saved?.should == false

      cloned_post.save.should == true
      cloned_post.id.should_not be(@post1.id)

      cloned_post.blog.id.should be(@post1.blog.id)
    end

    it "should clone single objects saved" do
      cloned_post = @post1.deep_clone(:create)

      cloned_post.title.should == @post1.title
      cloned_post.saved?.should == true
      cloned_post.id.should_not be(@post1.id)

      cloned_post.blog.id.should be(@post1.blog.id)
    end

    it "should handle many to many relations" do
      cloned_post = @post2.deep_clone(:create)

      cloned_post.related_posts.map(&:id).should =~ [@post1.id]
    end

  end

  describe "recursive cloning" do

    before(:all) do
      @blog = Blog.create(:name => 'Test Blog')
      @post1 = Post.create(:title => 'First post', :text => "Sun is shining...", :blog => @blog)
      @post2 = Post.create(:title => 'Second post', :text => "Now the moon is shining", :blog => @blog, :related_posts => [@post1])
    end

    it "should handle many to many relations" do
      cloned_post = @post2.deep_clone(:create, :related_posts)

      cloned_post.related_posts.map(&:id).should_not include(@post1.id)
      cloned_post.related_posts.map(&:title).should include(@post1.title)
    end

    it "should handle nested recursive relations" do
      cloned_post = @post1.deep_clone(:create, :blog => :posts)

      cloned_post.blog.posts.map(&:id).should_not include(@post1.id, @post2.id)
    end

    it "should be able to handle empty relations" do
      emtpy_blog = Blog.create(:name => 'An empty blog')
      cloned_blog = emtpy_blog.deep_clone(:posts)

      cloned_blog.posts.should be_empty
    end

    it "should not save new objects if not specified" do
      *old_counts = Blog.count, Post.count

      cloned_blog = @blog.deep_clone(:posts)

      cloned_blog.saved?.should be(false)
      cloned_blog.posts.map(&:saved?).should_not include(true)
      cloned_blog.posts.map(&:id).compact.should be_empty
      Blog.count.should be(old_counts[0])
      Post.count.should be(old_counts[1])
    end

  end
end
