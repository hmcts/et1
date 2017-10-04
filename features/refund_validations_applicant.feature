Feature: Refund Validations - Applicant page
  In order to ensure that the information provided to the business is
  as accurate as possible, field level validation is required to show
  the user where they have gone wrong before they move on to the next step
  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I am on the landing page
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed

  Scenario: A user does not fill in any fields in the applicant step after answering the name change question as no
    When I answer No to the has your name changed question for refunds
    And I save the refund applicant details
    Then the user should be informed that there are errors on the refund applicant page
    And all mandatory fields in the refund applicant page should be marked with an error
    And I take a screenshot named "Page 2 - Applicant with errors"

  Scenario: A user does not fill in any fields in the applicant step
    Then the continue button should be disabled on the refund applicant page

  Scenario: A user answers yes to the name changed question in the applicant step
    When I answer Yes to the has your name changed question for refunds
    Then the continue button should be disabled on the refund applicant page



