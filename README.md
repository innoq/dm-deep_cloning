# Datamapper deep cloning extention

This [DataMapper](http://github.com/datamapper) extension adds deep cloning functionality to your resource objects.
You can use it to recursively clone objects following spefic relations which need to be specified explicitly.

## Usage

Given the following models:

    class Blog
      has n, :posts
    end
   
    class Post
      belongs_to :blog
    end   

Cloning a blog including all its posts would look like:

    new_blog = blog.deep_clone(:posts)
   
This would initialize a new Blog object with all attrbutes taken from the original `blog`.  `new_blog.posts` would 
consist of (unsaved) clones of the original entrys from `blog.posts`.

If you don't want just to initialize the clones but to create them to, use `:create` as first parameter:

    new_blog = blog.deep_clone(:create, :posts)

### Nested recursion

Given a further model `Comment`:

    class Comment
      belongs_to :post
    end
    
    Post.has n, :comments

You can also specify nested parameters like:

    blog.deep_clone(:posts => :comments)
    
It's also possible to spcify Arrays of relation names.    