class ApplicationController < ActionController::Base
  # TODO remove
  # protect_from_forgery with: :exception


  def check_authenticated
    unless @user
      @user = User.new
      @user.id = '1'
    end
  end
end
