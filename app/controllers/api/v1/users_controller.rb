module Api
  module V1
    class UsersController < ApplicationController
      def index
        @data = User.all.map{ |u|
          {
            id: u.id,
            name: u.name,
            profile: u.profile,
            created_at: u.created_at
          }
        }
        render json: { status: 'SUCCESS', data: @data }
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
