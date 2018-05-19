class DeletePayolaPayments < ActiveRecord::Migration[5.2]
  def change
    drop_table :payola_products
  end
end
