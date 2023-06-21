require 'rails_helper' 

RSpec.describe CategoriesController, type: :controller do
  describe "CategoriesController crud" do
    before do
      @user = User.create({user_name: 'test', email: 'test@gmail.com', password: '123456'})
      session[:user_id] = @user.id
      @c = Category.create({name: 'testing'})
    end

    context "GET /index" do  
      before do
        get :index
      end

      it 'is expected to assign category instance variable' do
        category = Category.all
        expect(assigns[:categories]).to eq(Category.all)
      end
    end

    context 'GET #new' do
      before do
        get :new
      end

      it 'is expected to assign category as new instance variable' do
        expect(assigns[:category]).to be_instance_of(Category)
      end

      it 'renders new template' do
        is_expected.to render_template(:new)
      end

      it 'renders application layout' do
        is_expected.to render_template(:application)
      end
    end

    # create action
    context 'POST #create' do
      before do
          post :create, params: params
      end

      context 'when params are correct' do
        let(:params) { { category: { name: "Abhishek kanojia" } } }

        it 'is expected isSaveCategory to be true' do
          expect(assigns[:isSaveCategory]).to be true
        end

        it 'is expected to redirect to categories path' do
          is_expected.to redirect_to categories_path
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq('The new category was saved successfully!')
        end
      end

      context 'when params are not correct' do
        let(:params) { { category: { name: '' } } }

        it 'is expected isSaveCategory to be false' do
          expect(assigns[:isSaveCategory]).to be false
        end

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end
      end
    end

    context 'GET #edit' do
      before do
        get :edit, params: {id: @c.id}
      end

      context 'when params are correct' do
        it 'is expected to assign category variable' do
          expect(assigns[:category]).to eq(Category.find_by_id(@c.id))
        end
    
        it 'renders edit template' do
          is_expected.to render_template(:edit)
        end
    
        it 'renders application layout' do
          is_expected.to render_template(:application)
        end
      end
    end

    # update action
    context 'PATCH #update' do
      before do
        patch :update, params: { id: @c.id, category: { name: "testing edited" } }
      end

      context 'when data is provided is valid' do
        it 'is expected isUpdateSave to be true' do
          expect(assigns[:isUpdateSave]).to be true
          expect(Category.find_by_id(@c.id).name).to eq "testing edited"
        end

        it 'is_expected to redirect_to categories_path' do 
          is_expected.to redirect_to(categories_path)
        end
      end
    end

  # delete action
    context 'DELETE #destroy' do
      context 'when data is provided is valid' do
        before do
          delete :destroy, params: { id: @c.id}
        end
        it 'is expected category to be deleted' do
          expect(Category.find_by_id(@c.id)).to be_nil
        end

        it 'is_expected to redirect_to categories_path' do 
          is_expected.to redirect_to(categories_path)
        end
      end
    end
  end
end
