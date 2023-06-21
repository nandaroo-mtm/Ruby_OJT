class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user
  helper_method :logged_in
  include ApplicationHelper

  def authenticate
    return unless session[:user_id]

    redirect_to posts_path
  end
end
