class SessionsController < ApplicationController
  skip_before_action :authorized, only: %i[new create welcome]
  # before_action :authenticate, only: [:new]

  def create
    @user = User.find_by(email: params[:email])
    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to posts_path
    else
      flash[:notice] = "Email and password doesn't match!"
      redirect_to login_path
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end

  def welcome; end
end
