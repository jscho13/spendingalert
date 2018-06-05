class AddTrialPeriodToSubscriptionPlan < ActiveRecord::Migration[5.2]
  def change
    add_column :subscription_plans, :trial_period_days, :integer
  end
end
