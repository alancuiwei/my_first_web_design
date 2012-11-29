class AddDividendtypeAndDividendvalueAndPeriodAndRiskvalueToProduct < ActiveRecord::Migration
  def change
    add_column :product, :dividendtype, :string
    add_column :product, :dividendvalue, :float
    add_column :product, :period, :float
    add_column :product, :riskvalue, :float
  end
end
