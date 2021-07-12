class MigrateMultipleRespondents < ActiveRecord::Migration[6.0]
  class Respondent < ::ActiveRecord::Base
    self.table_name = :respondents
  end

  class Claim < ::ActiveRecord::Base
    self.table_name = :claims
    has_many :secondary_respondents, -> { where primary_respondent: false },
             class_name: "MigrateMultipleRespondents::Respondent"
  end

  def up
    Claim.all.each do |claim|
      claim.update_columns has_multiple_respondents: claim.secondary_respondents.count > 0
    end
  end

  def down
    # Pointless undoing this
  end
end
