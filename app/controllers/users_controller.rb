class UsersController < ApplicationController
    def new
        if( account )
            flash.notice = 'You are already logged in.'
            redirect_to(root_path)
        end
        @user = User.new()
    end

    def create
        @user = User.new(params[:user].permit(:name, :email, :password, :profile))
        if( @user.save )
            session[:user_id] = @user.id
            redirect_to(root_path , notice: 'User registration is completed.')
        else
            redirect_back(fallback_location: root_path)
        end
    end
end
