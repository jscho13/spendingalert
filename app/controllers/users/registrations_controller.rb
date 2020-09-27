# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers
  include HTTParty
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  def create
    super
    response = HTTParty.post("https://www.google.com/recaptcha/api/siteverify", :body => {secret: ENV['G_RECAPTCHA_SECRET'], response: params['g-recaptcha-response']})

    if response["success"]
# These resource create_mx_guid, calls dont work. It's not getting the right user model?
#       puts "resource #{resource}"
#       u = User.find(resource.id) 
#       puts "user #{u}"
# 
#       puts "creating mx guid"
#       u.create_mx_guid
#       puts "creating stripe id"
#       u.create_stripe_id

      UserMailer.signed_up_email(resource).deliver
      flash.notice = "Thanks for signing up. We've sent you a confirmation email to make sure you're human!"
    else
      flash.notice = "We're sorry, there was an error signing you up! Call us directly and we'll get it fixed for you."
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
