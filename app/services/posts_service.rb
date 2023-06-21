class PostsService
  class << self
    def listAll
      @posts = PostsRepository.listAll
    end

    def newPost
      @post = PostsRepository.newPost
    end

    def createPost(post)
      @post = PostsRepository.createPost(post)
    end

    def findPostById(id)
      @post = PostsRepository.findPostById(id)
    end

    def updatePost(id, post_form)
      @post = PostsRepository.findPostById(id)
      isUpdatePost = PostsRepository.updatePost(@post, post_form)
    end

    def deletePost(id)
      @post = PostsRepository.findPostById(id)
      PostsRepository.deletePost(@post)
    end
  end
end
