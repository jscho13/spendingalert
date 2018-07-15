class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :phone_number, phone: true

  attr_accessor :total_spending, :members

  def send_message
    message = "SpendingAlert:\n
              $#{self.user_budget} Spending Limit\n
              $#{self.current_spending} Spent so far\n
              $#{self.user_budget-self.current_spending} left to spend or save!"
    TwilioTextMessenger.new(message).call(self.phone_number)
  end

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
      binding.pry
      self.update_attribute(:guid, user.guid)
    rescue
      users = ::Atrium::User.list
      users.each do |user|
        if self.id == user.identifier.to_i
          u = User.find(self.id)
          u.update_attribute(:guid, user.guid)
        end
      end
      logger.debug "Updated User #{self.id} with guid #{self.guid}"
    end
  end

end
