class PostsRepository
  class << self
    def listAll
      @posts = Post.order('id desc')
    end

    def newPost
      @post = Post.new
    end

    def createPost(post)
      @post = Post.new(post)
    end

    def findPostById(id)
      @post = Post.find(id)
    end

    def updatePost(post, post_form)
      post.update(post_form)
    end

    def deletePost(post)
      post.destroy
    end
  end
end
