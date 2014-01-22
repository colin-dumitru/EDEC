require 'net/http'

class ApplicationController < ActionController::Base
  @@token_cache = {}

  def initialize

  end

  def check_authenticated
    @token = request.headers['Authorization']

    unless @token
      return render(:json => { error: 'Missing Authorization Token'}, :status => 401, :layout => false)
    end

    @user = @@token_cache[@token]

    unless @user
      url = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#{@token}"

      @user = User.new

      json = JSON.parse(
          Net::HTTP.get(URI.parse(url))
      )

      if json['user_id']
        @user.id = json['user_id']
        @@token_cache[@token] = @user
      else
        return render(:json => json, :status => 401, :layout => false)
      end

    end
  end
end
