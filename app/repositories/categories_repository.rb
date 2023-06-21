class CategoriesRepository
  class << self
    def listAll
      @categoreies = Category.order('id desc')
    end

    def newCategory
      @category = Category.new
    end

    def createCategory(category)
      @category = Category.new(category)
      isSaveCategory = @category.save
    end

    def findCategoryById(id)
      @category = Category.find_by_id(id)
    end

    def updateCategory(category, category_form)
      isUpdateCategory = category.update(category_form)
    end

    def deleteCategory(category)
      category.destroy
    end
  end
end
