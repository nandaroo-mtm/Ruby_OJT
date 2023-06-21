class UsersController < ApplicationController
  skip_before_action :authorized, only: %i[new create]
  # before_action :authenticate, only: [:new]

  def new
    @user = UsersService.newUser
  end

  def create
    @user = UsersService.createUser(user_params)
    if @user.valid?
      @user.save
      redirect_to login_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end
