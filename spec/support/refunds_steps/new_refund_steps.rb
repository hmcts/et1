def and_i_start_a_new_refund
  visit '/apply/refund'
end

def when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
  visit '/apply/refund'
  refund_profile_selection_page.select_profile_question.set('I was an individual claimant who made the payments set out in this application and have not been reimbursed by anyone pursuant to an order of the Tribunal')
  refund_profile_selection_page.save_and_continue.click
end

def when_i_start_a_new_refund_for_an_individual_claimant_whos_representative_paid_the_fees_and_the_indivual_reimbursed_them
  visit '/apply/refund'
  refund_profile_selection_page.select_profile_question.set('I was an individual claimant whose representative paid the fee and I then reimbursed them')
  refund_profile_selection_page.save_and_continue.click
end
