class SubscriptionsController < ApplicationController
  def new
  end

  def create
  end

  def dashboard
    @user = current_user
  end
end
