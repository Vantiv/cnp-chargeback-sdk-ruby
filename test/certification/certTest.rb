require File.expand_path("../../../lib/CnpOnline",__FILE__)
#require 'Cnp_activemerchant'
require 'test/unit'

module CnpOnline
  class Cnp_certTest < Test::Unit::TestCase
    @@config_hash = Configuration.new.config
    @@config_hash['url'] = 'https://services.vantivprelive.com/services/chargebacks/'
    CYCLE_FIRST_CHARGEBACK = "First Chargeback"
    CYCLE_PRE_ARB_CHARGEBACK = "Pre-Arbitration"
    CYCLE_ARBITRATION_CHARGEBACK = "VISA Pre-Arbitration/Arbitration"
    CYCLE_ISSUER_DECLINE_PRESAB = "Issuer Declined Pre-Arbitration"
    ACTIVITY_MERCHANT_REPRESENT = "Merchant Represent"
    ACTIVITY_MERCHANT_ACCEPTS_LIABILITY = "Merchant Accepts Liability"
    ACTIVITY_ADD_NOTE = "Add Note"

    def test_1
      response = ChargebackRetrieval.new.get_chargebacks_by_date(activity_date: "2013-01-01", config: @@config_hash)
      cases = response['chargebackCase']
      #test_chargeback_case(cases[0], "1111111111", CYCLE_FIRST_CHARGEBACK)
      test_chargeback_case(cases[1], "2222222222", CYCLE_FIRST_CHARGEBACK)
      test_chargeback_case(cases[2], "3333333333", CYCLE_FIRST_CHARGEBACK)
      test_chargeback_case(cases[3], "4444444444", CYCLE_FIRST_CHARGEBACK)
      test_chargeback_case(cases[4], "5555555550", CYCLE_PRE_ARB_CHARGEBACK)
      test_chargeback_case(cases[5], "5555555551", CYCLE_PRE_ARB_CHARGEBACK)
      test_chargeback_case(cases[6], "5555555552", CYCLE_PRE_ARB_CHARGEBACK)
      test_chargeback_case(cases[7], "6666666660", CYCLE_ARBITRATION_CHARGEBACK)
      test_chargeback_case(cases[8], "7777777770", CYCLE_ISSUER_DECLINE_PRESAB)
      test_chargeback_case(cases[9], "7777777771", CYCLE_ISSUER_DECLINE_PRESAB)
      test_chargeback_case(cases[10], "7777777772", CYCLE_ISSUER_DECLINE_PRESAB)
    end

    def test_2
      case_id = get_case_id_for_arn("1111111111")
      ChargebackUpdate.new.add_note_to_case(case_id: case_id, note: "Cert test2", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_ADD_NOTE, activity['activityType'])
      assert_equal("Cert test2", activity['notes'])
    end

    def test_3_1
      case_id = get_case_id_for_arn("2222222222")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test3_1", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_REPRESENT, activity['activityType'])
      assert_equal("Cert test3_1", activity['notes'])
    end

    def test_3_2
      case_id = get_case_id_for_arn("3333333333")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test3_2", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_REPRESENT, activity['activityType'])
      assert_equal("Cert test3_2", activity['notes'])
    end

    def test_4_and_5_1
      case_id = get_case_id_for_arn("4444444444")
      ChargebackUpdate.new.assume_liability(case_id: case_id, note: "Cert test4", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_ACCEPTS_LIABILITY, activity['activityType'])
      assert_equal("Cert test4", activity['notes'])

      exception = assert_raise(RuntimeError){ChargebackUpdate.new.assume_liability(case_id: case_id, note: "Cert test5_1", config: @@config_hash)}
      assert_equal("Error with http http_post_request, code:400", exception.message)
      end

    def test5_2
      exception = assert_raise(RuntimeError){ChargebackRetrieval.new.get_chargeback_by_case_id(case_id: "12345", config: @@config_hash)}
      assert_equal("Error with http http_post_request, code:404", exception.message)
    end

    def test_6_1
      case_id = get_case_id_for_arn("5555555550")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test6_1", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_REPRESENT, activity['activityType'])
      assert_equal("Cert test6_1", activity['notes'])
    end

    def test_6_2
      case_id = get_case_id_for_arn("5555555551")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test6_2", representment_amount: 10051, config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_REPRESENT, activity['activityType'])
      assert_equal(10051, activity['settlementAmount'])
      assert_equal("Cert test6_2", activity['notes'])
    end

    def test_7
      case_id = get_case_id_for_arn("5555555552")
      ChargebackUpdate.new.assume_liability(case_id: case_id, note: "Cert test7", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_ACCEPTS_LIABILITY, activity['activityType'])
      assert_equal("Cert test7", activity['notes'])
    end

    def test_8
      case_id = get_case_id_for_arn("6666666660")
      ChargebackUpdate.new.assume_liability(case_id: case_id, note: "Cert test8", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_ACCEPTS_LIABILITY, activity['activityType'])
      assert_equal("Cert test8", activity['notes'])
    end

    def test_9_1
      case_id = get_case_id_for_arn("7777777770")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test9_1", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_REPRESENT, activity['activityType'])
      assert_equal("Cert test9_1", activity['notes'])
    end

    def test_9_2
      case_id = get_case_id_for_arn("7777777771")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test9_2", representment_amount: 10071, config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_REPRESENT, activity['activityType'])
      assert_equal(10071, actvity['settlementAmount'])
      assert_equal("Cert test9_2", activity['notes'])
    end

    def test_10
      case_id = get_case_id_for_arn("7777777772")
      ChargebackUpdate.new.represent_case(case_id: case_id, note: "Cert test10", config: @@config_hash)
      activity = get_last_activity(case_id)

      assert_equal(ACTIVITY_MERCHANT_ACCEPTS_LIABILITY, activity['activityType'])
      assert_equal("Cert test10", activity['notes'])
    end

    def test_chargeback_case(chargeback_case, arn, chargeback_cycle)
      assert_equal(arn, chargeback_case['acquirerReferenceNumber'])
      assert_equal(chargeback_cycle, chargeback_case['cycle'])
    end

    def get_case_id_for_arn(arn)
      response = ChargebackRetrieval.new.get_chargebacks_by_arn(arn: arn, config: @@config_hash)
      return response['chargebackCase']['caseId']
    end

    def get_last_activity(case_id)
      response = ChargebackRetrieval.new.get_chargeback_by_case_id(case_id: case_id, config: @@config_hash)
      chargeback_case = response['chargebackCase']
      return chargeback_case['activity'][0]
    end
  end
end