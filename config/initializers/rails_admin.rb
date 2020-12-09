RailsAdmin.config do |config|
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  #   config.authorize_with do
  #     redirect_to main_app.root_path unless current_user.admin?
  #   end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    edit
    delete
    bulk_delete
  end

  config.model User do
    list do
      field :email
      field :phone_number do
        column_width 100
      end
      field :guid
      field :user_budget do
        column_width 80
      end
      field :confirmed_at
      field :admin
    end
  end
end
