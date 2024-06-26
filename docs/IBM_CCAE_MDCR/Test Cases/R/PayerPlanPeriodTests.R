# might not need this
#' @export
createPayerPlanPeriodTests <- function () {

  if (tolower(frameworkType) != "mdcd") {

  patient<-createPatient()
  declareTest(id = patient$person_id, "Person does not have prescription benefits and is excluded. Id is PERSON_ID.")
  add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", datatyp="1", plantyp="6", rx="0")
  expect_no_payer_plan_period(person_id = patient$person_id)

  }

  if (tolower(frameworkType) == "ccae") {
    patient<-createPatient()
    declareTest(id = patient$person_id, "Person has a gap of >32 days between enrollment periods with the same payer_source_value; person has two records. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", datatyp="1", plantyp="6")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-05-01", dtend="2013-05-31", datatyp="1", plantyp="6")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-01-01", payer_plan_period_end_date="2013-01-31", payer_source_value="N Commercial PPO")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-05-01", payer_plan_period_end_date="2013-05-31", payer_source_value="N Commercial PPO")

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person has a gap of <32 days between enrollment periods with the same payer_source_value; person has ONE records. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", datatyp="1", plantyp="6")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-02-05", dtend="2013-02-28", datatyp="1", plantyp="6")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-01-01", payer_plan_period_end_date="2013-02-28", payer_source_value="N Commercial PPO")
    expect_count_payer_plan_period(person_id=patient$person_id, rowCount=1)

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person switches plans in the middle of an enrollment period; person has two records with the first truncated. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", datatyp="2", plantyp="6")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-07", dtend="2012-04-30", datatyp="2", plantyp="5")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-01", payer_plan_period_end_date="2012-04-06", payer_source_value="C Commercial PPO")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-07", payer_plan_period_end_date="2012-04-30", payer_source_value="C Commercial POS")

    patient<-createPatient()
    declareTest(id = patient$person_id, "Family source value derived from ENROLID. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", datatyp="2", plantyp="6")
    family_source_value_expected_statement <- paste0("SUBSTRING(RIGHT('00000000000' + CONVERT(VARCHAR,", patient$enrolid, "), 11), 1,9)")
    class(family_source_value_expected_statement) <- 'subQuery'
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-01", payer_plan_period_end_date="2012-04-30", payer_source_value="C Commercial PPO", family_source_value=family_source_value_expected_statement)

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person does not have prescription benefits and is excluded. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", datatyp="1", plantyp="6", rx="0")
    expect_no_payer_plan_period(person_id = patient$person_id)

  }

  if (tolower(frameworkType) == "mdcr") {
    patient<-createPatient()
    declareTest(id = patient$person_id, "Person has a gap of >32 days between enrollment periods with the same payer_source_value; person has two records. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", datatyp="1", plantyp="6")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-05-01", dtend="2013-05-31", datatyp="1", plantyp="6")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-01-01", payer_plan_period_end_date="2013-01-31", payer_source_value="N Medicare PPO")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-05-01", payer_plan_period_end_date="2013-05-31", payer_source_value="N Medicare PPO")

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person switches plans in the middle of an enrollment period; person has two records with the first truncated. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", datatyp="2", plantyp="6")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-07", dtend="2012-04-30", datatyp="2", plantyp="5")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-01", payer_plan_period_end_date="2012-04-06", payer_source_value="C Medicare PPO")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-07", payer_plan_period_end_date="2012-04-30", payer_source_value="C Medicare POS")

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person has duplicate records, only one is brought into the cdm. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", datatyp="2", plantyp="6")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", datatyp="2", plantyp="6")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-01", payer_plan_period_end_date="2012-04-30", payer_source_value="C Medicare PPO")
  }

  if (tolower(frameworkType) == "mdcd") {

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person has a gap of >32 days between enrollment periods with the same payer_source_value; person has two records. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", medicare="1", plantyp="6", cap = "1")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-05-01", dtend="2013-05-31", medicare="1", plantyp="6", cap = "1")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-01-01", payer_plan_period_end_date="2013-01-31", payer_source_value="D C Medicaid PPO")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2013-05-01", payer_plan_period_end_date="2013-05-31", payer_source_value="D C Medicaid PPO")

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person does not have prescription benefits and is excluded. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2013-01-01", dtend="2013-01-31", plantyp="6", drugcovg ="0", medicare="0")
    expect_no_payer_plan_period(person_id = patient$person_id)

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person switches plans in the middle of an enrollment period; person has two records with the first truncated. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", medicare="1", plantyp="6", cap = "1")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-07", dtend="2012-04-30", medicare="1", plantyp="5", cap = "1")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-01", payer_plan_period_end_date="2012-04-06", payer_source_value="D C Medicaid PPO")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-07", payer_plan_period_end_date="2012-04-30", payer_source_value="D C Medicaid POS")

    patient<-createPatient()
    declareTest(id = patient$person_id, "Person has duplicate records, only one is brought into the cdm. Id is PERSON_ID.")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", medicare="1", plantyp="6", cap="1")
    add_enrollment_detail(enrolid=patient$enrolid, dtstart="2012-04-01", dtend="2012-04-30", medicare="1", plantyp="6", cap="1")
    expect_payer_plan_period(person_id=patient$person_id, payer_plan_period_start_date="2012-04-01", payer_plan_period_end_date="2012-04-30", payer_source_value="D C Medicaid PPO")
  }
}
