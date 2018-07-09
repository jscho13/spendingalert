class AddUserNotificationSettings < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :notificationInterval, :string
    add_column :users, :notificationType, :string
  end

  def down
    remove_column :users, :notificationInterval
    remove_column :users, :notificationType
  end
end
