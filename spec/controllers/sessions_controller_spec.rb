require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in
    !current_user.nil?
  end

  describe "SessionsController crud" do
    before do
      User.create({user_name: 'test', email: 'test@gmail.com', password: '123456'});
    end

    context "GET /login" do

      context 'when params are correct' do
        before do
          post :create, params: { email: 'test@gmail.com', password: '123456' }
        end

        it "is expected to assign session user_id" do
          expect(session[:user_id]).to_not be_nil
        end
  
        it "is expected to redirect to post list page" do 
          expect(response).to redirect_to(posts_path)
        end
  
        it "is expected to current_user variable not to be nil" do
          expect(current_user).to_not be_nil
          expect(current_user.email).to eq('test@gmail.com')
        end
  
        it "is expected to logged_in method return true" do
          expect(logged_in).to be true
        end
      end

      context 'when params are invalid' do
        before do
          post :create, params: { email: 'test@gmail.com', password: 'asdfghjkl' }
        end

        it "is expected to session user_id to be nil" do
          expect(session[:user_id]).to be_nil
        end

        it "is expected to set flash message" do 
          expect(flash[:notice]).to eq("Email and password doesn't match!")
        end

        it "is expected to redirect login_path" do 
          is_expected.to redirect_to(login_path)
        end
      end

    end

    context "DELETE /logout" do
      before do
        post :create, params: { email: 'test@gmail.com', password: '123456' }
        delete :destroy
      end

      it "is expected to session user_id to be nil" do 
        expect(session[:user_id]).to be_nil
      end

      it "is expected to redirect to login_path" do 
        is_expected.to redirect_to(login_path)
      end

      it "is expected to current_user vairable to be nil" do 
        expect(current_user).to be_nil
      end

      it "is expected to logged_in method return false" do 
        expect(logged_in).to be false
      end
    end
  end
end