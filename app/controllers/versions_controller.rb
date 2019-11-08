class VersionsController < ApplicationController
    def new
        @app = App.find_by(appid: params[:app_appid])
        unless( account )
            flash.notice = 'Need to login to create versions.'
            redirect_to(root_path)
            return
        end
        if( @app&.user_id != account.id )
            flash.notice = 'You cannnot create versions to this app.'
            redirect_to( '/'+@app&.appid )
            return
        end
        @version = Version.new()
    end

    def create
        @app = App.find_by(appid: params[:app_appid])
        unless( account || @app )
            flash.notice = 'Need to login to create versions.'
            redirect_to(root_path)
            return
        end

        begin
            response = Net::HTTP.get_response( URI.parse(params[:path] + 'define.json') )
            code = response.code
        rescue => exception
            flash.notice = exception
            redirect_to('/' + @app.appid)
            return
        end

        if code == '200'
            result = ActiveSupport::JSON.decode response.body
        else
            flash.notice = 'Cannot reach to define.json at the directory. Please enter correct directory of the kit app with character "/" at the end.'
            redirect_to('/' + @app.appid)
            return
        end
          
        params[:app_id] = @app.id
        @version = Version.new(params.permit(:name, :path, :app_id, :desc))
        if( @version.save )
            redirect_to("/#{@app.appid}" , notice: "Version registration is completed. An app '#{result["id"]}' was recognized at the directory.")
        else
            redirect_back(fallback_location: root_path)
        end
    end

    def edit
        @app = App.find_by(appid: params[:app_appid])
        @version = Version.find_by( public_uid: params[:public_uid] )
        unless @version
            redirect_to("/#{@app.appid}" , notice: 'Version not found.')
            return
        end
        if @app.user_id != account&.id
            redirect_to("/#{@app.appid}" , notice: 'You cannnot edit this app.')
            return
        end
    end

    def update
        @version = Version.find_by( id: params[:id] )
        @app = @version.app
        if @app.user_id != account.id
            redirect_to("/#{@app.appid}" , notice: 'You cannnot edit this app.')
            return
        end

        begin
            response = Net::HTTP.get_response( URI.parse(params[:version][:path] + 'define.json') )
            code = response.code
        rescue => exception
            flash.notice = exception
            redirect_to('/' + @app.appid)
            return
        end

        if code == '200'
            result = ActiveSupport::JSON.decode response.body
        else
            flash.notice = 'Cannot reach to define.json at the directory. Please enter correct directory of the kit app with character "/" at the end.'
            redirect_to('/' + @app.appid)
            return
        end

        if @version.update(params[:version].permit(:name, :path, :desc))
            flash.notice = "The version has been updated. An app '#{result["id"]}' was recognized at the directory."
            redirect_to('/' + @app.appid)
        else
            flash.notice = "Failed to update your profile."
            redirect_to('/' + @app.appid)
        end
    end
end
