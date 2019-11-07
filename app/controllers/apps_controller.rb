class AppsController < ApplicationController
    def new
        unless( account )
            flash.notice = 'Need to login to register apps.'
            redirect_to(root_path)
        end
        @app = App.new
    end

    def create
        unless( account )
            flash.notice = 'Need to login to register apps.'
            redirect_to(root_path)
        end
        params[:app][:user_id] = account.id
        @app = App.new(params[:app].permit(:name, :appid, :user_id, :desc))
        if( @app.save )
            redirect_to('/' + @app.apppid , notice: 'App registration is completed.')
        else
            redirect_back(fallback_location: root_path)
        end
    end

    def show
        @app = App.find_by(appid: params[:appid])
        @versions = @app.versions
    end

    def edit
        @app = App.find_by(appid: params[:appid])
        unless account&.name == @app.user.name
            redirect_to(login_path , notice: 'You cannot edit this app.')
        end
    end

    def update
        @app = App.find_by(id: params[:appid])
        if @app && account&.name == @app.user.name && @app.update(params[:app].permit(:appid, :name, :desc))
            flash.notice = "App has been updated."
            redirect_to '/' + @app.appid
        else
            flash.notice = "Failed to update an app."
            redirect_to root_path
        end
    end

    def index
        @apps = App.all
    end
end
