class AddDefaultToNotificationInterval < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :notification_interval, :string, default: "interval_5_days"
  end

  def down
    change_column :users, :notification_interval, :string, default: nil
  end
end
