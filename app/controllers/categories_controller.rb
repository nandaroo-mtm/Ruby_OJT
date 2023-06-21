class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    # @categories = CategoriesService.listAll
  end

  def new
    @category = CategoriesService.newCategory
  end

  def create
    @isSaveCategory = CategoriesService.createCategory(category_params)
    if @isSaveCategory
      flash[:notice] = 'The new category was saved successfully!'
      redirect_to categories_path
    else
      # redirect_to new_categories_path
      render :new
    end
  end

  def edit
    @category = CategoriesService.findCategoryById(params[:id])
  end

  def update
    @isUpdateSave = CategoriesService.updateCategory(params[:id], category_params)
    if @isUpdateSave
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    CategoriesService.deleteCategory(params[:id])
    redirect_to categories_path
  end

  def export
    @categories = CategoriesService.listAll

    respond_to do |format|
      format.html
      format.csv { send_data @categories.to_csv, filename: "categories-#{Date.today}.csv" }
    end
  end

  def import; end

  def import_file
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?

    unless params[:file].content_type == 'text/csv'
      return redirect_to request.referer,
                         notice: 'Only CSV files allowed'
    end

    msg = Category.import(params[:file])
    if msg != 'error'
      redirect_to categories_path
    else
      flash.now[:notice] = 'Errors occured!'
      render :import
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
