function OriginalCaseDetailsPage() {
  function publishCurrentAddressChanged() {
    let val = $(".refunds_original_case_details [name='refunds_original_case_details[address_changed]']:checked").val();
  }
  function publishCurrentHadRepresentative() {
    let val = $(".refunds_original_case_details [name='refunds_original_case_details[address_changed]']:checked").val();
  }
  function publishCurrentValues() {
    publishCurrentAddressChanged();
    publishCurrentHadRepresentative();
  }
  publishCurrentValues();
}
export default OriginalCaseDetailsPage;
