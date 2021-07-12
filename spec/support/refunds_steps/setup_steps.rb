def given_i_am_luke_skywalker
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H 9AJ'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  email_address: 'test@digital.justice.gov.uk'
end

def given_i_am_anakin_skywalker
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           post_code: 'SW1H 9AJ'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890'
end

def and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
  respondent_address = OpenStruct.new post_code: 'SW1H 9QR',
                                      building: '106',
                                      street: 'Petty France',
                                      locality: 'London',
                                      county: 'Greater London'

  respondent = OpenStruct.new name: 'Respondent Name',
                              address: respondent_address

  fees = OpenStruct.new et_issue_fee: '1000',
                        et_issue_payment_method: 'Card',
                        et_issue_payment_date: '1/2016',
                        et_hearing_fee: '1001',
                        et_hearing_payment_method: 'Cash',
                        et_hearing_payment_date: '2/2016',
                        eat_issue_fee: '1002',
                        eat_issue_payment_method: 'Cheque',
                        eat_issue_payment_date: '3/2016',
                        eat_hearing_fee: '1003',
                        eat_hearing_payment_method: 'Don\'t know',
                        eat_hearing_payment_date: '4/2016',
                        et_reconsideration_fee: '1004',
                        et_reconsideration_payment_method: 'Card',
                        et_reconsideration_payment_date: nil,
                        et_reconsideration_payment_date_unknown: true

  test_user.et_claim_to_refund = OpenStruct.new et_case_number: '1234567/2016',
                                                eat_case_number: 'UKEAT/1234/16/123',
                                                et_tribunal_office: 'Newcastle',
                                                additional_information: 'REF1, REF2, REF3',
                                                respondent: respondent.freeze,
                                                fees: fees.freeze,
                                                et_country_of_claim: 'England & Wales'

end

def and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2015
  respondent_address = OpenStruct.new building: '106',
                                      street: 'Petty France'

  respondent = OpenStruct.new name: 'Respondent Name',
                              address: respondent_address

  fees = OpenStruct.new et_issue_fee: '1000',
                        et_issue_payment_method: 'Card',
                        et_issue_payment_date: '4/2016'

  test_user.et_claim_to_refund = OpenStruct.new respondent: respondent.freeze,
                                                fees: fees.freeze,
                                                et_country_of_claim: 'England & Wales'

end

def and_i_have_a_bank_account
  test_user.bank_account = OpenStruct.new account_name: 'Mr Luke Skywalker',
                                          bank_name: 'Starship Enterprises Bank',
                                          account_number: '12345678',
                                          sort_code: '012345'
end

def and_i_have_a_building_society_account
  test_user.building_society_account = OpenStruct.new account_name: 'Mr Luke Skywalker',
                                                      building_society_name: 'Starship Enterprises Building Society',
                                                      account_number: '12345678',
                                                      sort_code: '012345'
end

def and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
  test_user.has_name_changed = 'No'
end

def and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
  test_user.claim_address_changed = 'No'
  test_user.et_claim_to_refund.address = test_user.address
end

def and_my_address_has_changed_since_the_original_claim_that_i_want_a_refund_for
  test_user.claim_address_changed = 'Yes'
  test_user.et_claim_to_refund.address = OpenStruct.new building: '104',
                                                        street: 'Petty Belgium',
                                                        locality: 'London',
                                                        county: 'Greater London',
                                                        post_code: 'SW1H 9BK'
end

def and_my_address_has_changed_minimal_details_since_the_original_claim_that_i_want_a_refund_for
  test_user.claim_address_changed = 'Yes'
  test_user.et_claim_to_refund.address = OpenStruct.new building: '104',
                                                        street: 'Petty Belgium',
                                                        post_code: 'SW1H 9BK'
end

def and_i_did_not_have_a_representative
  test_user.et_claim_to_refund.has_representative = 'No'
  test_user.et_claim_to_refund.representative = nil
end

def and_i_had_a_representative
  representative_address = OpenStruct.new post_code: 'SW2H 9ST',
                                          building: '108',
                                          street: 'Petty France',
                                          locality: 'London',
                                          county: 'Greater London'

  representative = OpenStruct.new name: 'Representative Name',
                                  address: representative_address

  test_user.et_claim_to_refund.has_representative = 'Yes'
  test_user.et_claim_to_refund.representative = representative
end

def and_i_had_a_representative_with_minimal_details
  representative_address = OpenStruct.new post_code: 'SW2H 9ST',
                                          building: '108',
                                          street: 'Petty France'

  representative = OpenStruct.new name: 'Representative Name',
                                  address: representative_address

  test_user.et_claim_to_refund.has_representative = 'Yes'
  test_user.et_claim_to_refund.representative = representative
end

def and_i_did_not_have_an_eat_issue_fee
  fees = test_user.et_claim_to_refund.fees.to_h.delete_if { |(k, _v)| k.to_s.start_with?('eat_issue') }
  test_user.et_claim_to_refund.fees = OpenStruct.new(fees).freeze
end
