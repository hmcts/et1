function publishCurrentAccountType() {
  let val = $('.refunds_bank_details [name=\'refunds_bank_details[payment_account_type]\']').val();
  setContinueButtonDisabled(val);
}

function setContinueButtonDisabled(val) {
  $('.refunds_bank_details .behavior-continue-button').prop('disabled', val === '');
}

function enableContinueWhenAllowed() {
  $(".refunds_bank_details [name='refunds_bank_details[payment_account_type]']").on('change', function(event, val) {
    setContinueButtonDisabled(val);

  });
}

function RefundBankDetailsPage() {
  enableContinueWhenAllowed();
  publishCurrentAccountType();
}

export default RefundBankDetailsPage;
