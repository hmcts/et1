# frozen_string_literal: true

# This type is used for 2 reasons
# 1. To allow defaulting for things like dates with no day (for refunds)
# 2. To fix a bug in rails where a user entering invalid values (e.g 32 in the day field) would
#     raise an ActiveRecord::MultiparameterAssignmentErrors.  We now ignore this (as if it was nil) so
#     the user gets an error on the form instead.
class EtDateType < ActiveRecord::Type::Date
  # @param [Boolean] omit_day If true, allows a date without a day - will default to the first of the month
  def initialize(omit_day: false, allow_2_digit_year: false)
    @omit_day = omit_day
    @allow_2_digit_year = allow_2_digit_year
    super()
  end

  private

  attr_reader :omit_day, :allow_2_digit_year

  def new_date(year, mon, mday)
    if allow_2_digit_year && year.present? && year < 100
      year = 1900 + year
    end
    super(year, mon, mday)
  end

  def value_from_multiparameter_assignment(value)
    defaults = {}
    defaults[3] = 1 if omit_day
    super defaults.merge(value)
  rescue ArgumentError
    value
  end
end
