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
require File.expand_path("../../../lib/CnpOnline",__FILE__)
require 'test/unit'

module CnpOnline
  class TestChargebackUpdate < Test::Unit::TestCase

    def test_assign_case_to_user
      response = ChargebackUpdate.new.assign_case_to_user(case_id: 10000, user_id: "jdeo@company.com", note: "Test note")
      assert_match(/\d+/, response.transactionId)
    end

    def test_add_note_to_case
      response = ChargebackUpdate.new.add_note_to_case(case_id: 10000, note: "Test note")
      assert_match(/\d+/, response.transactionId)
    end

    def test_assume_liability
      response = ChargebackUpdate.new.assume_liability(case_id: 10000, note: "Test note")
      assert_match(/\d+/, response.transactionId)
    end

    def test_represent_case
      response = ChargebackUpdate.new.represent_case(case_id: 10000, note: "Test note", representment_amount: 12000)
      assert_match(/\d+/, response.transactionId)
    end

    def test_represent_case_full
      response = ChargebackUpdate.new.represent_case(case_id: 10000, note: "Test note")
      assert_match(/\d+/, response.transactionId)
    end

    def respond_to_retrieval_request
      response = ChargebackUpdate.new.respond_to_retrieval_request(case_id: 10000, note: "Test note")
      assert_match(/\d+/, response.transactionId)
    end

    def test_request_arbitration
      response = ChargebackUpdate.new.request_arbitration(case_id: 10000, note: "Test note")
      assert_match(/\d+/, response.transactionId)
    end

    def test_add_not_to_case
      exception = assert_raise(RuntimeError){ChargebackUpdate.new.add_note_to_case(case_id: 404, note: "ErrorResponse")}
      assert_equal("Error with http response, code:404", exception.message)
    end
  end
end
