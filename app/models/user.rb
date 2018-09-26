class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :phone_number, phone: true

  attr_accessor :members,
                :updated_total_spending,
                :amount_left

  def has_guid?
    if self.guid.nil?
      create_mx_user
      false
    else
      true
    end
  end

  def notify_user
    case self.notification_type
    when "email"
      notify_email
    when "text"
      notify_text
    when "email_text"
      notify_email_text
    else
      log_stderr("User #{self.id}: has no notification type")
    end
  end

  def notification_date?
    case self.notification_interval
    when "interval_5_days"
      return check_interval_5_days
    when "interval_weekly"
      return check_interval_weekly
# This won't work. We need to convert percent into a dollar amount
#     when "interval_percent"
#       return check_interval_value("notification_percent")
    when "interval_limit"
      return check_interval_value("user_budget")
    else 
      log_stderr("User #{self.id}: has no interval")
      return false;
    end
  end

  def get_all_transactions
    params = { user_guid: self.guid }
    from_date = Date.today - Date.today.mday + 1

    transactions = ::Atrium::Transaction.list params
    transactions.select { |i| Date.parse(i.date) >= from_date }
  end

  def compose_message
    message =
<<-HEREDOC
SpendingAlert:
$#{self.user_budget} Spending Limit
$#{self.total_spending} Spent so far
HEREDOC
    if (self.total_spending <= self.user_budget)
      message +
<<-HEREDOC
$#{self.user_budget - self.total_spending} left to spend!\n
Good job you are on track to save this month!
HEREDOC
    else
      message +
<<-HEREDOC
You've overspent by $#{self.total_spending - self.user_budget}!\n
Slow down your on a spending spree!
HEREDOC
    end
  end



  private

  def check_interval_5_days
    today = Date.today
    [5, 10, 15, 20, 25, today.end_of_month.mday].include?(today.mday)
  end

  def check_interval_weekly
    today = Date.today
    [7, 14, 21, today.end_of_month.mday].include?(today.mday)
  end

  def check_interval_value(field)
    self.alert_sent_flag = false if Date.today.mday == 1

    if !self.alert_sent_flag
      transactions = self.get_all_transactions
      self.total_spending = transactions.sum(&:amount)

      if self.total_spending < self[field] 
        return false
      else
        self.alert_sent_flag = true
        return true
      end
    end
  end

  def notify_email
  end

  def notify_text
    message = compose_message
    puts "Message composed as: #{compose_message}"
    TwilioTextMessenger.new(message).call(self.phone_number)
  end

  def notify_email_text
    notify_email
    notify_text
  end

  def create_mx_user
    begin
      user = ::Atrium::User.create identifier: "#{self.id}", is_disabled: "", metadata: "{\"email\": \"#{self.email}\"}"
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
