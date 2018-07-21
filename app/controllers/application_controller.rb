class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?

  def log_stderr(output)
    Rails.logger.warn(
      "Stderr contents: #{output}"
    )
  end

  def log_stdout(output)
    Rails.logger.info(
      "Stdout contents: #{output}"
    )
  end

  protected

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def configure_permitted_parameters
    attributes = [:phone_number]
		devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
		devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end
end
