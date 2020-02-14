class CreateWatchlist < ActiveRecord::Migration[5.0]
  def change
    create_table :watchlists do |t|
      t.string :symbol
      t.integer :price
      t.integer :user_id
    end
  end
end
