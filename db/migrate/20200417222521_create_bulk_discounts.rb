class CreateBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.integer :discount_percentage
      t.integer :item_threshold
    end
  end
end
