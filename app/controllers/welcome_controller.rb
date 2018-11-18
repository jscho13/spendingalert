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
    all_users = User.all
    all_users.select { |u| !u.guid.nil? && !u.notification_interval.nil? }

    all_users.each do |u|
      u.update_total_spending
      if u.hit_budget_limit? || u.notification_date?
        unnotified_users << u
      end
    end
    puts "Unnotified users: #{unnotified_users}\n"

    unnotified_users
  end
end
