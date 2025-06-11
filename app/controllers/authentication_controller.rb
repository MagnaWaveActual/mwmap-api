class AuthenticationController < ApplicationController
    # skip_before_action :authenticate_token!
  
    def create
      if (user = User.find_by(email: params[:email])).nil?
        render json: { errors: 'User not Found' }, status: :unauthorized
      elsif user.valid_password? params[:password]
        # user.sign_in_count += 1
        # user.save
        object = {user_type: user.account_type, user_f_name: user.f_name, token: JsonWebToken.encode(sub: user.id) }
        render json: object
      else
        render json: { errors: 'unauthorized' }, status: :unauthorized
      end
    end
  
  end