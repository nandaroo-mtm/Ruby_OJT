class PostsController < ApplicationController
  def index
    @posts = PostsService.listAll.page params[:page]
    # @posts = Post.all
  end

  def show
    @post = PostsService.findPostById(params[:id])
  end

  def new
    @post = PostsService.newPost
    @categories = Category.all
  end

  def create
    @post = PostsService.createPost(post_params)
    @categories = CategoriesService.listAll
    if @post.save
      render json: @post, status: :created
      # # @post.save
      # flash[:notice] = 'The new post was saved successfully!'
      # redirect_to posts_path
    else
      # binding.pry
      @post.image = nil
      render :new
    end
  end

  def edit
    @post = PostsService.findPostById(params[:id])
    @categories = CategoriesService.listAll
  end

  def update
    @isUpdatePost = PostsService.updatePost(params[:id], post_params)
    if @isUpdatePost
      flash[:notice] = 'The selected post was updated!'
      redirect_to posts_path
    else
      flash[:notice] = 'Please fill correct data!'
      @post = PostsService.findPostById(params[:id])
      # redirect_to request.referer
      render :edit
    end
  end

  def destroy
    PostsService.deletePost(params[:id])
    flash[:notice] = 'The selected post was deleted successfully!'
    redirect_to posts_path
  end

  def export
    @posts = Post.select(:id, :title, :content, :category_id)

    respond_to do |format|
      format.html
      format.csv { send_data @posts.to_csv, filename: "posts-#{Date.today}.csv" }
    end
  end

  def import; end

  def import_file
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    msg = Post.import(params[:file])
    if msg != 'error'
      redirect_to posts_path
    else
      flash.now[:notice] = 'Errors occured!'
      render :import
    end

    # else
    #   flash[:notice] = 'Errors occured!'
    #   render :import
    # end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :category_id, :image)
  end
end
