class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      flash.now[:alert] = "Profile update failed."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name)
  end
end
