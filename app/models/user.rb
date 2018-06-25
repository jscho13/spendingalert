class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_first_sign_in?
    binding.pry
  end

  def create_mx_user
    user = ::Atrium::User.create identifier: "#{current_user.id}", is_disabled: "", metadata: "{\"email\": \"#{current_user.email}\"}"
    # update current_user here
    # current_user
  end    

end
