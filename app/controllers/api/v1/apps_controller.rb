module Api
  module V1
    class AppsController < ApplicationController
      protect_from_forgery
      
      def index
        render json: { status: 'SUCCESS', data: App.all }
      end

      def show
        @app = App.find_by( appid: params[:id] )
        if @app
          render json: { status: 'SUCCESS', data: @app, versions: @app.versions }
        else
          render json: { status: 'FAILED', error: "kpt: The app '#{params[:id]}' was not found." }
        end
      end

      def create
        params[:token] ||= 'dummy'
        @user = User.find_by(token: params[:token])
        if @user
          params[:user_id] = @user.id
          @app = App.new(params.permit(:name, :appid, :user_id, :desc))
          if @app.save
            render json: { status: 'SUCCESS', data: @app }
          else
            render json: { status: 'FAILED', error: @app.errors.full_messages }
          end
        else
          render json: { status: 'FAILED', error: "Token is invalid." }
        end
      end
    end
  end
end
