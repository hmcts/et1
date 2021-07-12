module ET1
  module Test
    class EmploymentUi
      attr_accessor :was_employed, :current_situation, :job_title,
                    :start_date, :end_date, :hours_worked_per_week, :gross_pay, :pay_period_type,
                    :net_pay, :notice_period_end_date, :worked_notice_period,
                    :notice_pay_period_count, :notice_pay_period_type, :in_pension_scheme, :benefits, :found_new_job,
                    :new_job_gross_pay_period_type, :new_job_gross_pay, :new_job_start_date

    end
  end
end
FactoryBot.define do
  factory :ui_employment, class: ::ET1::Test::EmploymentUi do
    trait :mandatory do
    end

    trait :default do
      mandatory
      was_employed { :'employment.was_employed.options.true' }
      current_situation { :'employment.current_situation.options.employment_terminated' }
      job_title { 'Super High Powered Exec' }
      start_date { '01/07/2000' }
      hours_worked_per_week { 37.5 }
      gross_pay { 10000 }
      pay_period_type { :'employment.pay_period_type.options.weekly' }
      net_pay { 6000 }
    end
  end
end
