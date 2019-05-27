class CreateRecentDealsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :recent_deals do |t|
      t.integer :price
      t.string :shape
      t.float :carat_weight
      t.string :color
      t.string :clarity
    end
  end
end