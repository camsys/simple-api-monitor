class UsersController < ApplicationController

  def index
    @staff = User.all.order(:email)
    @new_user= User.new 
  end

  def create
  	new_user = User.create(user_params)
  	if new_user.errors.empty?
      flash[:success] = 'Created ' + new_user.email
    else
      flash[:danger] = new_user.errors.first.join(' ') unless new_user.errors.empty?
    end
    respond_to do |format|
      format.js
      format.html {redirect_to users_path}
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
  	params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
