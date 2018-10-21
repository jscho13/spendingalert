class DefaultNotificationType < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :notification_type, :string, default: 'text'
  end

  def down
    change_column :users, :notification_type, :string, default: nil
  end
end
