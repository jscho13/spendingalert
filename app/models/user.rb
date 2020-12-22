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
        # UserCreateRequestBody | User object to be created with optional parameters (identifier, is_disabled, metadata)
        opts = {
          user: {
            identifier: self.id,
            is_disabled: "",
            metadata: "{\"email\": \"#{self.email}\"}"
          }
        }
        body = Atrium::UserCreateRequestBody.new(opts)

        # Create user
        user = GlobalAtrium.users.create_user(body).user
        self.update_attribute(:guid, user.guid)
      rescue Atrium::ApiError => e
        logger.error "Exception when calling UsersApi->create_user: #{e}"
        logger.error "User guid: #{self.guid}"
      end
    end
  end

  def delete_mx_guid
    begin
      #Delete user
      GlobalAtrium.users.delete_user(self.guid)
      return true
    rescue Atrium::ApiError => e
      logger.error "Exception when calling UsersApi->delete_user: #{e}"
      logger.error "User guid: #{self.guid}"
      return false
    end
  end

  def update_mx_guid
    # Updates user with MxID if they don't have one. Currently not used.
    # This function needs to be updated
    users = ::Atrium::User.list
    users.each do |user|
      if self.id == user.identifier.to_i
        u = User.find(self.id)
        u.update_attribute(:guid, user.guid)
      end
    end
    logger.debug "Updated User #{self.id} with guid #{self.guid}"
  end

  def create_stripe_id
    if self.stripe_customer_id.nil?
      begin
        customer = Stripe::Customer.create({
          email: self.email
        })
        self.update_attribute(:stripe_customer_id, customer.id)
      rescue
        logger.error "Unable to create stripe_customer_id for User ID: #{self.id}"
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


  def notification_date?
    case self.notification_interval
    when "interval_5_days"
      return check_interval_5_days
    when "interval_weekly"
      return check_interval_weekly
    when "interval_off"
      return false
    # set to interval_daily when testing with /send_message/:id
    when "interval_daily"
      return true
    else 
      log_stderr("User #{self.id}: has no interval")
      return false
    end
  end

  def get_all_transactions
    opts = {
      from_date: Date.new(Date.today.year, Date.today.month, 1), # String | Filter transactions from this date.
      to_date: Date.today, # String | Filter transactions to this date.
      records_per_page: 1000
    }

    begin
      #List transactions for a user
      transactions = GlobalAtrium.transactions.list_user_transactions(self.guid, opts).transactions
      transactions.select! do |t|
        t.category != "Transfer" && t.category != "Credit Card Payment"
      end
    rescue Atrium::ApiError => e
      puts "Exception when calling TransactionsApi->list_user_transactions: #{e}"
    end

    transactions 
  end

  def update_total_spending(members)
    begin
      members.each do |m|
        # Read member
        # member = GlobalAtrium.members.read_member(a_member.guid, self.guid)

        # Aggregate member
        member = GlobalAtrium.members.aggregate_member(m.guid, self.guid).member
        puts "User: #{self.id} was last successfully aggregated at #{member.successfully_aggregated_at}\n"
        puts member.to_s
      end

      transactions = self.get_all_transactions
      self.total_spending = transactions.sum(&:amount)
      self.save
    rescue
      puts "Error for User: #{self.id}, #{self.email}, when trying `update_total_spending`"
    end
  end

  def update_alert_sent_flag
    begin
      self.alert_sent_flag = true if self.total_spending > self.user_budget
      self.alert_sent_flag = false if Date.today.mday == 1
      self.save
    rescue
      puts "Error for User: #{self.id}, #{self.email}, when trying `update_alert_sent_flag`"
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
    begin
      opts = {
        page: 1, # Integer | Specify current page.
        records_per_page: 50, # Integer | Specify records per page.
      }

      #List members
      members = GlobalAtrium.members.list_members(self.guid, opts)
    rescue Atrium::ApiError => e
      puts "Exception when calling MembersApi->list_members: #{e}"
    end

    members.members
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
    TwilioTextMessenger.new(message).call(self.phone_number)
  end

  def notify_email_text
    notify_email
    notify_text
  end

end
