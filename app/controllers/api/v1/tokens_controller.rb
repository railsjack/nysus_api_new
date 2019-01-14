module Api
  module V1
    class TokensController  < ApplicationController
      skip_before_filter :verify_authenticity_token

      def create
        email = params[:email]
        password = params[:password]

        if request.format != :json
          render status: 406, json: {message: "The request must be json"}
          return
        end

        if email.blank? or password.blank?
          render status: 400, json: {
            message: "The request must contain the user email and password."
          }
          return
        end

        @user=User.find_by_email(email.downcase)

        if @user.nil?
          render status: 401, json: {message: "Invalid email or password."}
          return
        end

        if not @user.valid_password?(password)
          render status: 401, json: {message: "Invalid email or password."}
        else # make a new token and send it

          @user.authentication_token = generate_token
          @user.save!
          render json: {token: @user.authentication_token}
        end
      end

      def destroy
        @user=User.find_by_authentication_token(params[:id])
        if @user.nil?
          logger.info("Token not found.")
          render status: 404, json: {message: "Invalid token."}
        else
          @user.reset_authentication_token!
          render status: 200, json: {token: params[:id]}
        end
      end

      def generate_token
        o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        return (0...50).map { o[rand(o.length)] }.join
      end
    end
  end
end