class MigrateNoAcasNumberInRespondents < ActiveRecord::Migration[6.0]
  class Respondent < ::ActiveRecord::Base
    self.table_name = :respondents
  end

  def up
    Respondent.all.each do |respondent|
      respondent.update_columns no_acas_number: respondent.acas_early_conciliation_certificate_number.blank?
    end
  end

  def down
    # Pointless undoing this
  end

end
