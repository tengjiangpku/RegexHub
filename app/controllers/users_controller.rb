class UsersController < ApplicationController
    def new
        @user = User.new
    end
    
    # def index # probably should not be accessed.
    #     @users = User.all
    # end

    def create
        puts user_params
        puts params
        @user = User.new(user_params)
        if params[:user][:password]!=params[:user][:password_confirmation]
            flash[:notice] = "Password does not match!"
            render :new
        elsif @user.save
            session[:user_id] = @user.id
            redirect_to regexes_path
        else
            flash[:notice] = @user.errors.messages.map { |k,v| v }.join('<br>').html_safe
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
        @regexes = Regex.where(:user_id => params[:id])
        @likes = ActiveRecord::Base.connection.execute("SELECT R.id, R.title, R.description, R.created_at, R.expression, R.tag FROM regexes R, likes L WHERE L.regex_id = R.id AND L.user_id = #{params[:id]}")
    end

    private
    def user_params
        params.require(:user).permit(:username, :password)
    end
end