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
      #load configuration data
      @config_hash = Configuration.new.config
      @cnp_transaction = CnpTransaction.new
    end

    def get_chargebacks_by_date(activity_date, config=@config_hash)
      return _get_retrieval_response({date: activity_date}, config)
    end

    def get_chargebacks_by_financial_impact(activity_date, financial_impact, config=@config_hash)
      return _get_retrieval_response({date: activity_date, financialOnly: financial_impact}, config)
    end

    def get_actionable_chargebacks(actionable, config=@config_hash)
      return _get_retrieval_response({actionable: actionable}, config)
    end

    def get_chargeback_by_case_id(case_id, config=@config_hash)
      request_url =  config['url'] + "/" + case_id
      return Communications.http_get_retrieval_request(request_url, config)
    end

    def get_chargebacks_by_token(token, config=@config_hash)
      return _get_retrieval_response({token: token}, config)
    end

    def get_chargebacks_by_card_number(card_number, expiration_date, config=@config_hash)
      return _get_retrieval_response({cardNumber: card_number, expirationDate: expiration_date}, config)
    end

    def get_chargebacks_by_arn(arn, config=@config_hash)
      return _get_retrieval_response({arn: arn}, config)
    end


    def _get_retrieval_response(parameters, config)
      request_url = config['url']
      prefix = "?"

      parameters.each_key do |name|
        request_url += prefix + name.to_s + "=" + parameters[name]
        prefix = "&"
      end

      return Communications.http_get_retrieval_request(request_url, config)
    end

  end
end
