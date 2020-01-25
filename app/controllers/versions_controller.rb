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
            params[:def_version] = result["version"]
            params[:def_id] = result["id"]
            params[:def_name] = result["name"]
            params[:def_author] = result["author"]
        else
            flash.notice = 'Cannot reach to define.json at the directory. Please enter correct directory of the kit app with character "/" at the end.'
            redirect_to('/' + @app.appid)
            return
        end
          
        params[:app_id] = @app.id
        @version = Version.new(params.permit(:name, :path, :app_id, :desc, :def_version, :def_id, :def_name, :def_author))
        if( @version.save )
            redirect_to("/#{@app.appid}" , notice: "Version registration is completed. An app '#{result["id"]}' was recognized at the directory.")
        else
            redirect_back(fallback_location: root_path)
        end
    end

    def edit
        @version = Version.find_by( public_uid: params[:public_uid] )
        @app = @version.app
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

        params[:version][:def_version] = result["version"]
        params[:version][:def_id] = result["id"]
        params[:version][:def_name] = result["name"]
        params[:version][:def_author] = result["author"]

        if @version.update(params[:version].permit(:name, :path, :desc, :def_version, :def_id, :def_name, :def_author))
            flash.notice = "The version has been updated. An app '#{result["id"]}' was recognized at the directory."
            redirect_to('/' + @app.appid)
        else
            flash.notice = "Failed to update your profile."
            redirect_to('/' + @app.appid)
        end
    end

    def destroy
        @version = Version.find_by(id: params[:id])
        @app = @version.app
        unless account&.id == @app.user_id
            flash.notice = "You cannnot delete the version."
            redirect_to app_path @app.appid
        end
        if @version.destroy
            flash.notice = "Version was successfully deleted."
            redirect_to app_path @app.appid
        end
    end
end
