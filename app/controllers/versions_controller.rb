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
        params[:app_id] = @app.id
        @version = Version.new(params.permit(:name, :path, :app_id, :desc))
        if( @version.save )
            redirect_to("/#{@app.appid}" , notice: 'Version registration is completed.')
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
        if @version.update(params[:version].permit(:name, :path, :desc))
            flash.notice = "The version has been updated."
            redirect_to '/' + @app.appid
        else
            flash.notice = "Failed to update your profile."
            redirect_to '/' + @app.appid
        end
    end
end
