class AddSharesColumnToPortfolios < ActiveRecord::Migration[5.0]
  def change
    add_column :portfolios, :shares, :integer
  end
end
