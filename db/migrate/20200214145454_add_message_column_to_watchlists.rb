class AddMessageColumnToWatchlists < ActiveRecord::Migration[5.0]
  def change
    add_column :watchlists, :message, :string
  end
end
