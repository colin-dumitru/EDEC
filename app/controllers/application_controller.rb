class ApplicationController < ActionController::Base
  def check_authenticated
    unless @user
      @user = User.new
      @user.id = '1'
    end
  end
end
