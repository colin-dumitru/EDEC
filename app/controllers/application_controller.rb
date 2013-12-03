class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def check_authenticated
    unless @user
      @user = User.new
      @user.id = '1'
    end
  end
end
