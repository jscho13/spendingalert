class WelcomeController < ApplicationController
  def index
  end

  def dashboard
		@user = current_user
  end

  def sample_index
  end

  def sample_generic
  end

  def sample_elements
  end
end
