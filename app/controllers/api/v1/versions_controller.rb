module Api
  module V1
    class VersionsController < ApplicationController
      protect_from_forgery

      def create
        params[:token] ||= 'dummy'
        @app = App.find_by(appid: params[:app_id])
        @user = User.find_by(token: params[:token])
        if @user
          if @app.user_id == @user.id
            begin
              response = Net::HTTP.get_response( URI.parse(params[:path].to_s + 'define.json') )
              code = response.code
            rescue => exception
              render json: { status: 'FAILED', error: exception }
              return
            end
    
            if code == '200'
                result = ActiveSupport::JSON.decode response.body
                params[:def_version] = result["version"]
                params[:def_id] = result["id"]
                params[:def_name] = result["name"]
                params[:def_author] = result["author"]
            else
                render json: { status: 'FAILED', error: 'Cannot reach to define.json at the directory. Please enter correct directory of the kit app with character "/" at the end.' }
                return
            end
              
            params[:app_id] = @app.id
            @version = Version.new(params.permit(:name, :path, :app_id, :desc, :def_version, :def_id, :def_name, :def_author))

            if @version.save
              render json: { status: 'SUCCESS', data: @version, versions: @app.versions }
            else
              render json: { status: 'FAILED', error: @version.errors.full_messages }
            end
          else
            render json: { status: 'FAILED', error: "You don't have permission to change the app." }
          end
        else
          render json: { status: 'FAILED', error: "Token is invalid." }
        end
      end
    end
  end
end