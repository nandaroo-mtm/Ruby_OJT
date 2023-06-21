require 'rails_helper' 

RSpec.describe PostsController, type: :controller do

  def create_category_and_post
    @c = Category.create({name: 'testing cagegory'});
    @p = Post.create({title: 'testing title', content: 'We are going to write a simple application that finds factorial numbers.', 
      category_id: @c.id});
    @p.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'images.png')),
                        filename: 'images.png', content_type: 'image/png');
    @p.save
  end

  describe "PostsController crud" do
    before do
      @user = User.create({user_name: 'test', email: 'test@gmail.com', password: '123456'})
      session[:user_id] = @user.id
    end

    context "GET /index" do  
      before do
        create_category_and_post
        get :index
      end

      it 'is expected to assign posts instance variable' do
        expect(assigns[:posts]).to eq(PostsService.listAll.page)
      end
    end

    context "GET #show" do  
      before do
        create_category_and_post
        get :show, params: { id: @p.id } 
      end

      it 'is expected to assign posts instance variable', :slow do
        expect(assigns[:post]).to eq(Post.find_by_id(@p.id))
      end
    end

    context 'GET #new' do
      before do
        get :new
      end

      it 'is expected to assign post as new instance variable' do
        expect(assigns[:post]).to be_instance_of(Post)
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
        @c = Category.create({name: 'testing category'});
        post :create, params: params
      end

      context 'when params are correct' do
        let(:params) { { post: {title: 'testing title', content: 'We are going to write a simple application that finds factorial numbers.', 
                category_id: @c.id, image: fixture_file_upload(File.open(Rails.root.join('app', 'assets', 'images', 'images.png')), 'image/png')} } }

        it 'is expected isSaveCategory to be true' do
          expect(assigns[:post].save).to be true 
          expect(assigns[:post].title).to eq('testing title')
          expect(assigns[:post].category_id).to be @c.id
        end

        it 'is expected to redirect to posts path' do
          is_expected.to redirect_to posts_path
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq('The new post was saved successfully!')
        end
      end

      context 'when params are not correct(all nil)' do
        let(:params) { { post: {title: '', content: '', 
          category_id: nil } }}
        
        it 'is expected isSavePost to be false' do
          post = assigns[:post]
          expect(post.save).to be false
          expect(post.errors[:title][0]).to eq("Post title can't be blank")
          expect(post.errors[:content][0]).to eq("Content can't be blank")
          expect(post.errors[:category_id][0]).to eq('choose one category!')
          expect(post.errors[:image][0]).to eq("can't be blank")
        end

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end
      end

      context 'when params are not correct(too short title and content)' do
        let(:params) { { post: {title: 'test', content: 'We are going to', 
        category_id: @c.id} } }
        
        it 'is expected isSavePost to be false' do
          post = assigns[:post]
          expect(post.save).to be false
          expect(post.errors[:title][0]).to eq("10 characters is the minimum allowed")
          expect(post.errors[:content][0]).to eq("50 characters is the minimum allowed")
        end

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end
      end

      context 'when params are not correct(image validatiaon fials)' do
        let(:params) { { post: {title: 'testing title', content: 'We are going to write a simple application that finds factorial numbers.', 
              category_id: @c.id} } }
        
        it 'is expected isSavePost to be false' do
          post = assigns[:post]
          expect(post.save).to be false
          expect(post.errors[:image][0]).to eq("can't be blank")
        end

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end
      end

      context 'when params are not correct(invalid image files)' do
        let(:params) { { post: {title: 'testing title', content: 'We are going to write a simple application that finds factorial numbers.', 
              category_id: @c.id, image: fixture_file_upload(File.open(Rails.root.join('app', 'assets', 'images', 'posts-2023-05-30.csv')), 'csv')} } }
        
        it 'is expected isSavePost to be false' do
          post = assigns[:post]
          expect(post.save).to be false
          expect(post.errors[:image][0]).to eq("has an invalid content type")
        end

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end
      end
    end

    context 'GET #edit' do
      before do
        create_category_and_post
        get :edit, params: { id: @p.id }
      end

      it 'is expected to assign post as new instance variable' do
        expect(assigns[:post]).to eq(Post.find_by_id(@p.id))
      end

      it 'renders new template' do
        is_expected.to render_template(:edit)
      end

      it 'renders application layout' do
        is_expected.to render_template(:application)
      end
    end

    # delete action
    context 'DELETE #destroy' do
      context 'when data is provided is valid' do
        before do
          create_category_and_post
          delete :destroy, params: { id: @p.id}
        end
        it 'is expected category to be deleted' do
          expect(Post.find_by_id(@p.id)).to be_nil
          expect(flash[:notice]).to eq('The selected post was deleted successfully!')
        end

        it 'is_expected to redirect_to posts_path' do 
          is_expected.to redirect_to(posts_path)
        end
      end
    end

    # update action
    context 'PATCH #update' do
      before do
        create_category_and_post
        patch :update, params: { id: @p.id, post: post }
      end

      context 'when params are correct' do
        let(:post) { {title: 'testing title', content: 'We are going to write a simple application that finds factorial numbers.', 
                category_id: @c.id, image: fixture_file_upload(File.open(Rails.root.join('app', 'assets', 'images', 'images.png')), 'image/png')} }

        it 'is expected isUpdatePost to be true' do
          expect(assigns[:isUpdatePost]).to be true 
        end

        it 'is expected to redirect to posts path' do
          is_expected.to redirect_to posts_path
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq('The selected post was updated!')
        end
      end

      context 'when params are not correct(all nil)' do
        let(:post) { {title: '', content: '', 
          category_id: nil } }
        
        it 'is expected isUpdatePost to be false' do
          expect(assigns[:isUpdatePost]).to be false
        end

        it 'is expected to render new template' do
          is_expected.to render_template(:edit)
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq('Please fill correct data!')
        end
      end
    end
  end
end