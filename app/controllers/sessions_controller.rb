class SessionsController < ApplicationController
    def create
        @user = User.find_by_name(params[:name])
        if( @user && @user.authenticate(params[:password]) )
            session[:user_id] = @user.id
            flash.notice = 'Logged in.'
            redirect_to(root_path)
        else
            flash.notice = 'Failed to log in.'
            redirect_to('/login')
        end
    end

    def destroy
        @name = account.name
        session.delete(:user_id)
        flash.notice = "Logged out from #{@name}."
        redirect_to(:root)
    end
end
