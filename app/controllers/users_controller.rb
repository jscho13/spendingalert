class UsersController < ApplicationController
  def update
		@user = current_user
    @user.update(user_params)
    if @user.save
      flash.notice = "Budget saved successfully"
      redirect_to dashboard_path
    else
      flash.notice = @user.errors.full_messages.join(". ")
      render dashboard_path
    end
  end

  def mx_create_user
    user = ::Atrium::User.create identifier: "#{current_user.id}", is_disabled: "", metadata: "{\"email\": \"#{current_user.email}\"}"
    render json: user.attributes
  end

  def mx_list_users
		users = ::Atrium::User.list
    render json: users
  end

	def mx_connect_widget
		@widget = ::Atrium::Connect.create user_guid: "USR-7f83326a-a003-fc1f-ee2a-1415bb6986b0"
		puts @widget.attributes
		render "subscriptions/new", layout: false
	end

	private

  def user_params
    params.require(:user).permit(
      :user_budget
    )
  end
end
