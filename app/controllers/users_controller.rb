class UsersController < ApplicationController
  def index
  end

  def update
		@user = current_user
    @user.update(user_params)
    if @user.save
      flash.notice = "Budget saved successfully"
    else
      flash.notice = @user.errors.full_messages.join(". ")
    end
  end

  def create
  end

  def destroy
  end

	private

  def user_params
    params.require(:user).permit(
      :user_budget
    )
  end
end
