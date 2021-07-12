class AddHasMultipleClaimantsToClaims < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :has_multiple_claimants, :boolean
  end
end
