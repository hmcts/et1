class MigrateMultipleClaimants < ActiveRecord::Migration[6.0]
  class Claimant < ::ActiveRecord::Base
    self.table_name = :claimants
  end

  class Claim < ::ActiveRecord::Base
    self.table_name = :claims
    has_many :secondary_claimants, -> { where primary_claimant: false },
             class_name: "MigrateMultipleClaimants::Claimant"
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns has_multiple_claimants: claim.secondary_claimants.count > 0
    end
  end

  def down
    # Pointless undoing this
  end
end
