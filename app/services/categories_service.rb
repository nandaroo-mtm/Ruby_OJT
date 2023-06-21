class CategoriesService
  class << self
    def listAll
      @categories = CategoriesRepository.listAll
    end

    def newCategory
      @category = CategoriesRepository.newCategory
    end

    def createCategory(category)
      isSaveCategory = CategoriesRepository.createCategory(category)
    end

    def findCategoryById(id)
      @category = CategoriesRepository.findCategoryById(id)
    end

    def updateCategory(id, category_form)
      @category = CategoriesRepository.findCategoryById(id)
      isUpdateCategory = CategoriesRepository.updateCategory(@category, category_form)
    end

    def deleteCategory(id)
      @category = CategoriesRepository.findCategoryById(id)
      CategoriesRepository.deleteCategory(@category)
    end
  end
end
