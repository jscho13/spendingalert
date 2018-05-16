class CreatePayolaProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :payola_products do |t|
      t.integer :price
      t.string :name
      t.string :permalink

      t.timestamps
    end
  end
end
