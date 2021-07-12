class AddHasMultipleRespondentsToClaims < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :has_multiple_respondents, :boolean
  end
end
