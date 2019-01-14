module Api
  module V1
    class UsersController < ApplicationController

      def show
        #if params["token"]?
          process_token
        #end
        if User.where(:id => @current_user.id).exists?
          @user = User.where(:id => @current_user.id).first
          # get favorites of the user
          #@user.favorites = Favorite.where(:user_id => @user.id).all
          render :show, formats: :json
        else
          render status: 200, json: {user: "User not found"}
        end
      end

      def process_token
        token = params[:token]
        @current_user = User.find_by_authentication_token(token)
      end
    end
  end
end
