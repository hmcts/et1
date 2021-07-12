# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_23_093709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "building"
    t.string "street"
    t.string "locality"
    t.string "county"
    t.string "post_code"
    t.integer "addressable_id"
    t.string "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "telephone_number"
    t.string "country"
    t.boolean "primary", default: true
  end

  create_table "claimants", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "mobile_number"
    t.string "fax_number"
    t.string "email_address"
    t.text "special_needs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "claim_id"
    t.string "gender"
    t.string "contact_preference"
    t.string "title"
    t.boolean "primary_claimant", default: false
    t.boolean "allow_video_attendance"
  end

  create_table "claims", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest"
    t.boolean "is_unfair_dismissal"
    t.integer "discrimination_claims"
    t.integer "pay_claims"
    t.text "other_claim_details"
    t.text "claim_details"
    t.integer "desired_outcomes"
    t.text "other_outcome"
    t.text "other_known_claimant_names"
    t.boolean "is_whistleblowing"
    t.boolean "send_claim_to_whistleblowing_entity"
    t.text "miscellaneous_information"
    t.string "fee_group_reference"
    t.string "state", default: "created"
    t.datetime "submitted_at"
    t.string "claim_details_rtf"
    t.string "email_address"
    t.string "additional_claimants_csv"
    t.integer "remission_claimant_count", default: 0
    t.integer "additional_claimants_csv_record_count", default: 0
    t.string "application_reference", null: false
    t.string "pdf"
    t.string "confirmation_email_recipients", default: [], array: true
    t.string "pdf_url"
    t.boolean "has_multiple_claimants"
    t.boolean "has_multiple_respondents"
    t.index ["application_reference"], name: "index_claims_on_application_reference", unique: true
  end

  create_table "diversities", id: :serial, force: :cascade do |t|
    t.string "claim_type"
    t.string "sex"
    t.string "sexual_identity"
    t.string "age_group"
    t.string "ethnicity"
    t.string "ethnicity_subgroup"
    t.string "disability"
    t.string "caring_responsibility"
    t.string "gender"
    t.string "gender_at_birth"
    t.string "pregnancy"
    t.string "relationship"
    t.string "religion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employments", id: :serial, force: :cascade do |t|
    t.boolean "enrolled_in_pension_scheme"
    t.boolean "found_new_job"
    t.boolean "worked_notice_period_or_paid_in_lieu"
    t.date "end_date"
    t.date "new_job_start_date"
    t.date "notice_period_end_date"
    t.date "start_date"
    t.float "notice_pay_period_count"
    t.integer "gross_pay"
    t.integer "net_pay"
    t.integer "new_job_gross_pay"
    t.float "average_hours_worked_per_week"
    t.string "current_situation"
    t.string "pay_period_type"
    t.string "job_title"
    t.string "new_job_gross_pay_frequency"
    t.string "notice_pay_period_type"
    t.text "benefit_details"
    t.integer "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "claim_id"
    t.string "event"
    t.string "actor"
    t.string "message"
    t.string "claim_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offices", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.string "address"
    t.string "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "claim_id"
    t.string "email"
  end

  create_table "refunds", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "applicant_email_address", null: false
    t.string "application_reference", null: false
    t.integer "application_reference_number", null: false
    t.boolean "address_changed", null: false
    t.boolean "has_name_changed", null: false
    t.string "profile_type", null: false
    t.string "et_country_of_claim", null: false
    t.string "et_case_number", null: false
    t.string "et_tribunal_office", null: false
    t.string "respondent_name", null: false
    t.string "respondent_address_building", null: false
    t.string "respondent_address_street", null: false
    t.string "respondent_address_locality", null: false
    t.string "respondent_address_county", null: false
    t.string "respondent_address_post_code", null: false
    t.boolean "claim_had_representative", null: false
    t.string "representative_name", null: false
    t.string "representative_address_building", null: false
    t.string "representative_address_street", null: false
    t.string "representative_address_locality", null: false
    t.string "representative_address_county", null: false
    t.string "representative_address_post_code", null: false
    t.string "claimant_name", null: false
    t.text "additional_information", null: false
    t.decimal "et_issue_fee", precision: 10, scale: 2
    t.string "et_issue_fee_currency", default: "GBP"
    t.string "et_issue_fee_payment_method"
    t.decimal "et_hearing_fee", precision: 10, scale: 2
    t.string "et_hearing_fee_currency", default: "GBP"
    t.string "et_hearing_fee_payment_method"
    t.decimal "eat_issue_fee", precision: 10, scale: 2
    t.string "eat_issue_fee_currency", default: "GBP"
    t.string "eat_issue_fee_payment_method"
    t.decimal "eat_hearing_fee", precision: 10, scale: 2
    t.string "eat_hearing_fee_currency", default: "GBP"
    t.string "eat_hearing_fee_payment_method"
    t.decimal "et_reconsideration_fee", precision: 10, scale: 2
    t.string "et_reconsideration_fee_currency", default: "GBP"
    t.string "et_reconsideration_fee_payment_method"
    t.string "applicant_address_building", null: false
    t.string "applicant_address_street", null: false
    t.string "applicant_address_locality", null: false
    t.string "applicant_address_county", null: false
    t.string "applicant_address_post_code", null: false
    t.string "applicant_address_telephone_number", null: false
    t.string "applicant_first_name", null: false
    t.string "applicant_last_name", null: false
    t.date "applicant_date_of_birth"
    t.string "claimant_email_address"
    t.string "applicant_title", null: false
    t.string "payment_account_type", null: false
    t.string "payment_bank_account_name"
    t.string "payment_bank_name"
    t.string "payment_bank_account_number"
    t.string "payment_bank_sort_code"
    t.string "payment_building_society_account_name"
    t.string "payment_building_society_name"
    t.string "payment_building_society_account_number"
    t.string "payment_building_society_sort_code"
    t.boolean "accept_declaration", default: false, null: false
    t.string "claimant_address_building", null: false
    t.string "claimant_address_street", null: false
    t.string "claimant_address_locality", null: false
    t.string "claimant_address_county", null: false
    t.string "claimant_address_post_code", null: false
    t.date "et_issue_fee_payment_date"
    t.boolean "et_issue_fee_payment_date_unknown"
    t.date "et_hearing_fee_payment_date"
    t.boolean "et_hearing_fee_payment_date_unknown"
    t.date "et_reconsideration_fee_payment_date"
    t.boolean "et_reconsideration_fee_payment_date_unknown"
    t.date "eat_issue_fee_payment_date"
    t.boolean "eat_issue_fee_payment_date_unknown"
    t.date "eat_hearing_fee_payment_date"
    t.boolean "eat_hearing_fee_payment_date_unknown"
    t.datetime "submitted_at", null: false
    t.text "eat_case_number", null: false
  end

  create_table "representatives", id: :serial, force: :cascade do |t|
    t.string "type"
    t.string "organisation_name"
    t.string "name"
    t.string "mobile_number"
    t.string "email_address"
    t.string "dx_number"
    t.integer "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "contact_preference"
  end

  create_table "respondents", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "acas_early_conciliation_certificate_number"
    t.string "no_acas_number_reason"
    t.integer "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "worked_at_same_address", default: true
    t.boolean "primary_respondent", default: false
    t.boolean "no_acas_number"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.json "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "reference", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
