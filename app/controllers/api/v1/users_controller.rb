module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: { status: 'SUCCESS', data: User.all }
      end

      def show
        @user = User.find_by( nfcid: params[:id] )
      end
    end
  end
end
