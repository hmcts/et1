class RenameEmploymentPeriodTypeFields < ActiveRecord::Migration[6.1]
  def change
    rename_column :employments, :gross_pay_period_type, :pay_period_type
    remove_column :employments, :net_pay_period_type, :string
  end
end
