class AddBudgetToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_budget, :integer
  end
end
