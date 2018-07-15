class AlertSentFlag < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :alertSentFlag, :boolean, default: false
  end

  def down
    remove_column :users, :alertSentFlag
  end
end
