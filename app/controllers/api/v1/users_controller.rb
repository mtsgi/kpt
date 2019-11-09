module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: { status: 'SUCCESS', data: User.all }
      end

      def show
        @user = User.find_by( name: params[:id] )
        if @user
          render json: { status: 'SUCCESS', data: @user, apps: @user.apps }
        else
          render json: { status: 'FAILED', error: "kpt: The user '#{params[:id]}' was not found." }
        end
      end
    end
  end
end
