class AlertSentFlag < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :alert_sent_flag, :boolean, default: false
  end

  def down
    remove_column :users, :alert_sent_flag
  end
end
