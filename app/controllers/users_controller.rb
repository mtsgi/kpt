class UsersController < ApplicationController

    def new
        if( account )
            flash.notice = 'You are already logged in.'
            redirect_to(root_path)
        end
        @user = User.new()
    end

    def create
        @user = User.new(params[:user].permit(:name, :email, :password, :password_confirmation, :profile))
        if( @user.save )
            session[:user_id] = @user.id
            redirect_to(user_path(@user.name) , notice: 'User registration is completed.')
        else
            redirect_back(fallback_location: root_path)
        end
    end

    def show
        @user = User.find_by( name: params[:name] )
    end

    def edit
        if account
            @user = account
        else
            redirect_to(login_path , notice: 'You are not logged in.')
        end
    end

    def update
        if account.update(params[:user].permit(:name, :profile, :password))
            flash.notice = "Your profile has been updated."
            redirect_to user_path(account.name)
        else
            flash.notice = "Failed to update your profile."
            redirect_to user_path(account.name)
        end
    end
end
