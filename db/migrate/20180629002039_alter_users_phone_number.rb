class AlterUsersPhoneNumber < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :phone_number, :integer
    change_column_null :users, :phone_number, false, 0
  end

  def down
    change_column :users, :phone_number, :string
    change_column_null :users, :phone_number, true
  end
end
