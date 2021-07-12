class AddNoAcasNumberToRespondents < ActiveRecord::Migration[6.0]
  def change
    add_column :respondents, :no_acas_number, :boolean
  end
end
