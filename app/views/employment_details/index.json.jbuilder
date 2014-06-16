json.array!(@employment_details) do |employment_detail|
  json.extract! employment_detail, :id, :job_title, :start_date, :hours_worked, :pay_before_tax, :pay_before_tax_frequency, :take_home_pay, :take_home_pay_frequency, :pension_scheme, :details_of_benefit, :current_situation
  json.url employment_detail_url(employment_detail, format: :json)
end
