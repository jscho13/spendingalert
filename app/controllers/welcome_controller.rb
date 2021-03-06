class WelcomeController < ApplicationController
  def index
  end

  def sample_elements
  end

  def faq
  end

  def terms_and_conditions
  end

  def privacy_policy
  end

  # TODO: Move this to subscriptions controller
  def send_messages
    users_to_be_notified = get_unnotified_users
    users_to_be_notified.each do |u|
      u.notify_user
    end
    users_json = users_to_be_notified.to_json

    render json: users_json
  end

  private

  def get_unnotified_users
    unnotified_users = []
    all_users = User.all.select { |u| !u.guid.nil? && !u.notification_interval.nil? }

    all_users.each do |u|
      members = u.get_all_memberships
      u.update_total_spending(members)
      if u.notification_date? || (u.alert_sent_flag == false)
        unnotified_users << u
      end
      u.update_alert_sent_flag
    end
    puts "Unnotified users: #{unnotified_users}\n"

    unnotified_users
  end
end
