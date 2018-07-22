class AddNotificationTransactionToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :notification_percent, :integer, limit: 2
    add_column :users, :total_spending, :integer, limit: 8
  end

  def down
    remove_column :users, :notification_percent
    remove_column :users, :total_spending
  end
end
