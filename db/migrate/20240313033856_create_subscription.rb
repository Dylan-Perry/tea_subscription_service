class CreateSubscription < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :title
      t.float :price
      t.string :frequency
      t.integer :status, default: 1
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
