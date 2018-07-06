=begin
Copyright (c) 2018 Vantiv eCommerce

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end
require File.expand_path("../../../lib/CnpChargeback", __FILE__)
require 'test/unit'

module CnpOnline
  class TestChargebackRetrieval < Test::Unit::TestCase

    def test_activity_date
      response= ChargebackRetrieval.new.get_chargebacks_by_date(activity_date: "2018-01-01")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
    end

    def test_activity_date_financial_impact
      response= ChargebackRetrieval.new.get_chargebacks_by_financial_impact(activity_date: "2018-01-01", financial_impact:"true")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
    end

    def test_actionable
      response= ChargebackRetrieval.new.get_actionable_chargebacks(actionable: "true")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
    end

    def test_case_id
      response= ChargebackRetrieval.new.get_chargeback_by_case_id(case_id: "1333078000")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
      assert_equal("1333078000", response.chargebackCase.caseId)
    end

    def test_token
      response= ChargebackRetrieval.new.get_chargebacks_by_token(token: "1000000")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
      assert_equal("1000000", response.chargebackCase.token)
    end

    def test_card_number
      response= ChargebackRetrieval.new.get_chargebacks_by_card_number(card_number: "1111000011110000", expiration_date: "0118")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
      assert_equal("0000", response.chargebackCase.cardNumberLast4)
    end

    def test_arn
      response= ChargebackRetrieval.new.get_chargebacks_by_arn(arn: "1111111111")
      assert_match(/\d+/, response.chargebackCase.caseId)
      assert_match(/\d+/, response.transactionId)
      assert_equal("1111111111", response.chargebackCase.acquirerReferenceNumber)
    end

    def test_get_case_id
      exception = assert_raise(RuntimeError){ChargebackRetrieval.new.get_chargeback_by_case_id(case_id: "404")}
      assert_equal("Error with http response, code:404", exception.message)
    end

  end
end
