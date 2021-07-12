let privateFields = {};

function updateTotalFees() {
  let values = [];
  values.push(privateFields.etIssueFeeEl().val());
  values.push(privateFields.etHearingFeeEl().val());
  values.push(privateFields.etReconsiderationFeeEl().val());
  values.push(privateFields.eatIssueFeeEl().val());
  values.push(privateFields.eatHearingFeeEl().val());
  let total = values.reduce(function (sum, value) {
    if (value === '') {
      return sum;
    }
    return sum + parseFloat(value);
  }, 0);
  $('.refunds_fees span[data-behavior=\'total_fees\']').text(total.toFixed(2));
}

function enableOtherFieldsWhenAllowed() {
  privateFields.etIssueFeeEl().on('change keyup keypress', updateOtherFields);
  privateFields.etHearingFeeEl().on('change keyup keypress', updateOtherFields);
  privateFields.etReconsiderationFeeEl().on('change keyup keypress', updateOtherFields);
  privateFields.eatIssueFeeEl().on('change keyup keypress', updateOtherFields);
  privateFields.eatHearingFeeEl().on('change keyup keypress', updateOtherFields);
}

function updateTotalFeesOnChange() {
  privateFields.etIssueFeeEl().on('change keyup keypress', updateTotalFees);
  privateFields.etHearingFeeEl().on('change keyup keypress', updateTotalFees);
  privateFields.etReconsiderationFeeEl().on('change keyup keypress', updateTotalFees);
  privateFields.eatIssueFeeEl().on('change keyup keypress', updateTotalFees);
  privateFields.eatHearingFeeEl().on('change keyup keypress', updateTotalFees);
}

privateFields.etIssueFeeEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_issue_fee]\']');
};
privateFields.etIssueFeePaymentDateYearEl = function () {
  return $(".refunds_fees [name='refunds_fees[et_issue_fee_payment_date(1i)]']");
};
privateFields.etIssueFeePaymentDateMonthEl = function () {
  return $(".refunds_fees [name='refunds_fees[et_issue_fee_payment_date(2i)]']");
};
privateFields.etIssueFeePaymentDateUnknownEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_issue_fee_payment_date_unknown]\']');
};
privateFields.etIssueFeePaymentMethodEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_issue_fee_payment_method]\']');
};
privateFields.etHearingFeeEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_hearing_fee]\']');
};
privateFields.etHearingFeePaymentDateYearEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_date(1i)]\']');
};
privateFields.etHearingFeePaymentDateMonthEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_date(2i)]\']');
};
privateFields.etHearingFeePaymentDateUnknownEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_date_unknown]\']');
};
privateFields.etHearingFeePaymentMethodEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_hearing_fee_payment_method]\']');
};
privateFields.etReconsiderationFeeEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_reconsideration_fee]\']');
};
privateFields.etReconsiderationFeePaymentDateYearEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_date(1i)]\']');
};
privateFields.etReconsiderationFeePaymentDateMonthEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_date(2i)]\']');
};
privateFields.etReconsiderationFeePaymentDateUnknownEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_date_unknown]\']');
};
privateFields.etReconsiderationFeePaymentMethodEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[et_reconsideration_fee_payment_method]\']');
};

privateFields.eatIssueFeeEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_issue_fee]\']')
};
privateFields.eatIssueFeePaymentDateYearEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_date(1i)]\']');
};
privateFields.eatIssueFeePaymentDateMonthEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_date(2i)]\']');
};
privateFields.eatIssueFeePaymentDateUnknownEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_date_unknown]\']');
};
privateFields.eatIssueFeePaymentMethodEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_issue_fee_payment_method]\']');
};
privateFields.eatHearingFeeEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_hearing_fee]\']');
};
privateFields.eatHearingFeePaymentDateYearEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_date(1i)]\']');
};
privateFields.eatHearingFeePaymentDateMonthEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_date(2i)]\']');
};
privateFields.eatHearingFeePaymentDateUnknownEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_date_unknown]\']');
};
privateFields.eatHearingFeePaymentMethodEl = function () {
  return $('.refunds_fees [name=\'refunds_fees[eat_hearing_fee_payment_method]\']');
};

function updateOtherFields() {
  ['etIssue', 'etHearing', 'etReconsideration', 'eatIssue', 'eatHearing'].forEach(function (f) {
    let val = privateFields[f + 'FeeEl']().val();
    let disabled = (isNaN(val) || val == 0.0);
    setDisabledForFee(f, disabled);
  });
}

function setDisabledForFee(fee, value) {
  privateFields[fee + 'FeePaymentDateYearEl']().prop('disabled', value);
  privateFields[fee + 'FeePaymentDateMonthEl']().prop('disabled', value);
  privateFields[fee + 'FeePaymentDateUnknownEl']().prop('disabled', value);
  privateFields[fee + 'FeePaymentMethodEl']().prop('disabled', value);
}

function RefundFeesPage() {
  updateTotalFees();
  updateOtherFields();
  updateTotalFeesOnChange();
  enableOtherFieldsWhenAllowed();
}
export default RefundFeesPage;

