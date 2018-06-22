=begin
Copyright (c) 2017 Vantiv eCommerce

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
require_relative 'Configuration'

#
# This class handles sending the Cnp online request
#
module CnpOnline

  class ChargebackUpdate
    def initialize
      @config_hash = Configuration.new.config
    end

    def assign_case_to_user(case_id, user_id, note, config=@config_hash)
      update_request = build_request
      update_request.activityType = "ASSIGN_TO_USER"
      update_request.note = note
      update_request.assignedTo = user_id
      return _get_update_response(case_id, update_request, config)
    end

    def add_note_to_case(case_id, note, config=@config_hash)
      update_request = build_request
      update_request.activityType = "ADD_NOTE"
      update_request.note = note
      return _get_update_response(case_id, update_request, config)
    end

    def assume_liability(case_id, note, config=@config_hash)
      update_request = build_request
      update_request.activityType = "MERCHANT_ACCEPTS_LIABILITY"
      update_request.note = note
      return _get_update_response(case_id, update_request, config)
    end

    def represent_case(case_id, note, representment_amount=nil, config=@config_hash)
      update_request = build_request
      update_request.activityType = "MERCHANT_REPRESENT"
      update_request.note = note
      update_request.representedAmount = representment_amount
      return _get_update_response(case_id, update_request, config)
    end

    def respond_to_retrieval_request(case_id, note, config=@config_hash)
      update_request = build_request
      update_request.activityType = "MERCHANT_RESPOND"
      update_request.note = note
      return _get_update_response(case_id, update_request, config)
    end

    def request_arbitration(case_id, note, config=@config_hash)
      update_request = build_request
      update_request.activityType = "MERCHANT_REQUESTS_ARBITRATION"
      update_request.note = note
      return _get_update_response(case_id, update_request, config)
    end

    private

    def build_request()
      update_request = UpdateRequest.new
      update_request.xmlns = "http://www.vantivcnp.com/chargebacks"
      return update_request
    end

    def _get_update_response(parameter_value1, update_request, config)
      request_url =  config['url'] + "/" + parameter_value1.to_s
      request_xml = update_request.save_to_xml.to_s
      response_xml = Communications.http_put_update_request(request_url, request_xml, config)
      return XMLObject.new(response_xml)
    end

  end
end
