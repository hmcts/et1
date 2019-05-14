package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import com.typesafe.config._



class EmploymentTribunalsPerformance extends Simulation
with HttpConfiguration
{
  val conf = ConfigFactory.load()
  val baseurl = conf.getString("baseUrl")
  val httpconf = httpProtocol.baseURL(baseurl).disableCaching

  val scenario1 = scenario("Happy Path for Employment Tribunal Refunds")

    .exec(http("Start Session")
        .get("/apply/refund"))

    .exec(http("Store authenticity token")
        .get("/apply/refund/profile-selection")
        .check(css("input[name='authenticity_token']", "value").saveAs("csrfCookie")))

    //////  Page 1 of 7 - Introduction Page //////

    .exec(http("Page 1 of 7 - Introduction Page")
        .put("/apply/refund/profile-selection")
        .formParam("refunds_profile_selection[profile_type]", "claimant_direct_not_reimbursed")
        .formParam("authenticity_token", session => {
            session("csrfCookie").as[String]})
        .check(status.is(200)))

    //////  Page 2 of 7 - Claimant details //////

    .exec(http("Page 2 of 7 - Claimant details")
        .put("/apply/refund/applicant")
        .formParam("refunds_applicant[has_name_changed]", "false")
        .formParam("refunds_applicant[applicant_title]", "ms")
        .formParam("refunds_applicant[applicant_first_name]", "Sophie")
        .formParam("refunds_applicant[applicant_last_name]", "Smith")
        .formParam("refunds_applicant[applicant_date_of_birth][day]", "07")
        .formParam("refunds_applicant[applicant_date_of_birth][month]", "01")
        .formParam("refunds_applicant[applicant_date_of_birth][year]", "1983")
        .formParam("refunds_applicant[applicant_address_building]", "102")
        .formParam("refunds_applicant[applicant_address_street]", "Petty France")
        .formParam("refunds_applicant[applicant_address_locality]", "London")
        .formParam("refunds_applicant[applicant_address_county]", "")
        .formParam("refunds_applicant[applicant_address_post_code]", "SW1H 9AJ")
        .formParam("refunds_applicant[applicant_address_telephone_number]", "02074903123")
        .formParam("refunds_applicant[email_address]", "sophie@example.com")
        .formParam("authenticity_token", session => {
            session("csrfCookie").as[String]})
        .check(status.is(200)))

     //////  Page 3 of 7 - Details about your original case //////

     .exec(http("Page 3 of 7 - Details about your original case")
        .put("/apply/refund/original-case-details")
        .formParam("refunds_original_case_details[address_changed]", "false")
        .formParam("refunds_original_case_details[claimant_address_building]", "")
        .formParam("refunds_original_case_details[claimant_address_street]", "")
        .formParam("refunds_original_case_details[claimant_address_locality]", "")
        .formParam("refunds_original_case_details[claimant_address_county]", "")
        .formParam("refunds_original_case_details[claimant_address_post_code]", "")
        .formParam("refunds_original_case_details[claim_had_representative]", "false")
        .formParam("refunds_original_case_details[representative_name]", "")
        .formParam("refunds_original_case_details[representative_address_building]", "")
        .formParam("refunds_original_case_details[representative_address_street]", "")
        .formParam("refunds_original_case_details[representative_address_locality]", "")
        .formParam("refunds_original_case_details[representative_address_county]", "")
        .formParam("refunds_original_case_details[representative_address_post_code]", "")
        .formParam("refunds_original_case_details[respondent_name]", "Phil Smith")
        .formParam("refunds_original_case_details[respondent_address_building]", "101")
        .formParam("refunds_original_case_details[respondent_address_street]", "Petty France")
        .formParam("refunds_original_case_details[respondent_address_locality]", "London")
        .formParam("refunds_original_case_details[respondent_address_county]", "")
        .formParam("refunds_original_case_details[respondent_address_post_code]", "SW1H 9AJ")
        .formParam("refunds_original_case_details[et_country_of_claim]", "england_and_wales")
        .formParam("refunds_original_case_details[et_tribunal_office]", "")
        .formParam("refunds_original_case_details[et_case_number]", "")
        .formParam("refunds_original_case_details[eat_case_number]", "")
        .formParam("refunds_original_case_details[additional_information]", "")
        .formParam("authenticity_token", session => {
            session("csrfCookie").as[String]})
        .check(status.is(200)))

     //////  Page 4 of 7 - About the fees you paid //////

    .exec(http("Page 4 of 7 - About the fees you paid")
        .put("/apply/refund/fees")
        .formParam("refunds_fees[et_issue_fee]", "700")
        .formParam("refunds_fees[et_issue_fee_payment_date_unknown]", "1")
        .formParam("refunds_fees[et_issue_fee_payment_method]", "cheque")        
        .formParam("authenticity_token", session => {
            session("csrfCookie").as[String]})
        .check(status.is(200)))

    //////  Page 5 of 7 - Repayment Details //////

    .exec(http("Page 5 of 7 - Repayment Details")
        .put("/apply/refund/bank-details")
        .formParam("refunds_bank_details[payment_account_type]", "bank")
        .formParam("refunds_bank_details[payment_bank_name]", "hsbc")
        .formParam("refunds_bank_details[payment_bank_account_name]", "Phil Smith")
        .formParam("refunds_bank_details[payment_bank_account_number]", "00000000")
        .formParam("refunds_bank_details[payment_bank_sort_code]", "000000")
        .formParam("refunds_bank_details[payment_building_society_name]", "")
        .formParam("refunds_bank_details[payment_building_society_account_number]", "")
        .formParam("refunds_bank_details[payment_building_society_sort_code]", "")
        .formParam("authenticity_token", session => {
            session("csrfCookie").as[String]})
        .check(status.is(200)))

     //////  Page 6 of 7 - Review your application //////

    .exec(http("Page 6 of 7 - Review your application")
        .put("/apply/refund/review")
        .formParam("refunds_review[accept_declaration]", "1")
        .formParam("authenticity_token", session => {
            session("csrfCookie").as[String]})
        .check(status.is(200)))
    
    //////  Page 7 of 7 - Refund application submitted //////

     .exec(http("Page 7 of 7 - Refund application submitted")
        .get("/apply/refund/confirmation")
        .check(status.is(200)))

  val userCount = conf.getInt("users")
  val durationInSeconds  = conf.getLong("duration")

  setUp(
    scenario1.inject(rampUsers(userCount) over (durationInSeconds seconds)).protocols(httpconf)
  )

}
