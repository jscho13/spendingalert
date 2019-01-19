class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :phone_number, phone: true
  validate :password_complexity

  attr_accessor :members,
                :amount_left

  def create_mx_guid
    if self.guid.nil?
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

  def create_stripe_id
    if self.stripe_customer_id.nil?
      begin
        customer = Stripe::Customer.create({
          email: self.email
        })
        self.update_attribute(:stripe_customer_id, customer.id)
      rescue
        logger.debug "Unable to create stripe_customer_id for User ID: #{self.id}"
      end
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

  def reset_alert_sent_flag
    self.alert_sent_flag = false
    self.save
  end

  def notification_date?
    case self.notification_interval
    when "interval_5_days"
      return check_interval_5_days
    when "interval_weekly"
      return check_interval_weekly
# This won't work. We need to convert percent into a dollar amount
#       when "interval_percent"
#         return check_interval_value("notification_percent")
    when "interval_daily"
      return true
    else 
      log_stderr("User #{self.id}: has no interval")
      return false
    end
  end

  def get_all_transactions
    params = {
      from_date: Date.new(Date.today.year, Date.today.month, 1), # String | Filter transactions from this date.
      to_date: Date.today # String | Filter transactions to this date.
    }

    transactions = ::Atrium::Transaction.list_each(:user_guid => self.guid, :query_params => params) do |transaction|
      transaction.category != "Transfer" && transaction.category != "Credit Card Payment"
    end

    transactions 
  end

  def update_total_spending(members)
    begin
      members.each do |a_member|
        member = ::Atrium::Member.read user_guid: self.guid, member_guid: "#{a_member.guid}"
        member = member.aggregate
        puts "User: #{self.id}\n"
        puts "Last successfully aggregated: #{member.successfully_aggregated_at}\n"
        puts member.attributes
      end

      # update total_spending
      transactions = self.get_all_transactions
      self.total_spending = transactions.sum(&:amount)

      # update alert_sent_flag
      budget_limit_bool = self.total_spending > self['user_budget']
      reset_alert_sent_flag if Date.today.mday == 1
      self.alert_sent_flag = true if budget_limit_bool

      self.save
    rescue
      puts "Invalid guid for User: #{self.id}, #{self.email}"
    end
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

  def get_all_memberships
    ::Atrium::Member.list user_guid: "#{self.guid}"
  end

  private

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    errors.add :password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def check_interval_5_days
    today = Date.today
    [5, 10, 15, 20, 25, 30, today.end_of_month.mday].uniq.include?(today.mday)
  end

  def check_interval_weekly
    today = Date.today
    [7, 14, 21, 28, today.end_of_month.mday].uniq.include?(today.mday)
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

end
