class AddUserNotificationSettings < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :notification_interval, :string
    add_column :users, :notification_type, :string
  end

  def down
    remove_column :users, :notification_interval
    remove_column :users, :notification_type
  end
end
