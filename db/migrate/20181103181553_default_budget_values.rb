class DefaultBudgetValues < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :total_spending, :bigint, default: 0
    change_column :users, :user_budget, :integer, limit: 8, default: 0
  end
end
