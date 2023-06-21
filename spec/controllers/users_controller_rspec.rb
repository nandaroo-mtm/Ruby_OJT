require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'UsersController crud' do 

    context "GET #new" do 
      before do
        get :new
      end

      it "is expected to assign user as new instance variable" do 
        expect(assigns[:user]).to be_instance_of(User)
      end

      it "renders new template" do 
        is_expected.to render_template(:new)
      end

      it "renders layout template" do 
        is_expected.to render_template(:application)
      end
    end

    context "POST #create" do 
      before do 
        post :create, params: params
      end

      context "when params are valid" do 
        let(:params) { { user: { user_name: 'testing', email: 'test@gmail.com', password: '123456', 
          password_confirmation: '123456' } } }

        it "is expected to create new user successfully" do 
          user = assigns[:user]
          expect(user).to be_instance_of(User)
          expect(user.valid?).to be true
          expect(user.save).to be true
          expect(user.email).to eq('test@gmail.com')
        end

        it "expected to redirect to login_path" do 
          is_expected.to redirect_to(login_path)
        end
      end

      context "when params are invalid" do 
        let(:params) { { user: { user_name: '', email: '', password: '', 
          password_confirmation: '' } } }

        it "is expected not to save user successfully" do 
          user = assigns[:user]
          expect(user).to be_instance_of(User)
          expect(user.valid?).to be false
          expect(user.save).to be false
        end

        it "is expected to return validation errror messages" do 
          user = assigns[:user]
          expect(user.errors[:user_name][0]).to eq("Name field can't be blank!")
          expect(user.errors[:email][0]).to eq("Email field can't be blank!")
          expect(user.errors[:password][0]).to eq("6 characters is the minimum allowed")
          expect(user.errors[:password_confirmation][0]).to eq("Password confirmation doesn't match!")
        end

        it "is expected to render new template" do 
          is_expected.to render_template(:new)
        end
      end

      context "when email params is already used" do 
        before do
          post :create, params: { user: {user_name: 'test2', email: 'test@gmail.com', password: '123456',
            password_confirmation: '123456'} }
        end

        let(:params) { { user: { user_name: 'test1', email: 'test@gmail.com', password: '789456', 
          password_confirmation: '789456' } } }

        it "is expected to return email uniqueness error message" do 
          user = assigns[:user]
          expect(user.errors[:email][0]).to eq('This email has already been taken!')
        end 
      end

      context "when password is too short and confirmation is incorrect" do 

        let(:params) { { user: { user_name: 'test1', email: 'test@gmail.com', password: '78', 
          password_confirmation: '78sssssssss' } } }

        it "is expected to return password validation error message" do 
          user = assigns[:user]
          expect(user.errors[:password][0]).to eq('6 characters is the minimum allowed')
          expect(user.errors[:password_confirmation][0]).to eq("Password confirmation doesn't match!")
        end 
      end 
    end

  end
end 