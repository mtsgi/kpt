module Api
  module V1
    class AppsController < ApplicationController
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
    end
  end
end
