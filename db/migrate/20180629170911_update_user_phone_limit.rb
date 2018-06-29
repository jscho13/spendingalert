class UpdateUserPhoneLimit < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :phone_number, :integer, limit: 8
  end

  def down
    change_column :users, :phone_number, :integer, limit: 4
  end
end
