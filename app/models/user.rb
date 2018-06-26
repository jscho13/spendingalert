class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def has_guid?
    if self.guid.nil?
      create_mx_user
      false
    else
      true
    end
  end

  private

  def create_mx_user
    begin
      user = ::Atrium::User.create identifier: "#{self.id}", is_disabled: "", metadata: "{\"email\": \"#{self.email}\"}"
      update_attribute(:guid, user.guid)
    rescue
      users = ::Atrium::User.list
      users.each do |user|
        if self.id = user.identifier
          self.update_attribute(:guid, user.guid)
        end
      end
      logger.debug "Updated User #{self.id} with guid #{self.guid}"
    end
  end

end
