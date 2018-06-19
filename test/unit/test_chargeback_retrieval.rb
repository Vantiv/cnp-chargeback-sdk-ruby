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
require File.expand_path("../../../lib/CnpOnline",__FILE__)
require 'test/unit'
require 'mocha/setup'

module CnpOnline
  class TestSale < Test::Unit::TestCase
    def test_both_choices_fraud_check_and_card_holder
      hash = {
          'merchantId' => '101',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'cnpTxnId'=>'123456',
          'orderId'=>'12344',
          'amount'=>'106',
          'orderSource'=>'ecommerce',
          'fraudCheck'=>{'authenticationTransactionId'=>'123'},
          'cardholderAuthentication'=>{'authenticationTransactionId'=>'123'},
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000002',
              'expDate' =>'1210'
          }}

      exception = assert_raise(RuntimeError){CnpOnlineRequest.new.sale(hash)}
      assert_match /Entered an Invalid Amount of Choices for a Field, please only fill out one Choice!!!!/, exception.message
    end

    def test_success_applepay
      hash = {
          'merchantId' => '101',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'cnpTxnId'=>'123456',
          'orderId'=>'12344',
          'amount'=>'106',
          'orderSource'=>'ecommerce',
          'fraudCheck'=>{'authenticationTransactionId'=>'123'},
          'applepay'=>{
              'data'=>'user',
              'header'=>{
                  'applicationData'=>'454657413164',
                  'ephemeralPublicKey'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                  'publicKeyHash'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                  'transactionId'=>'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
              },
              'signature' =>'sign',
              # 'version' =>'1'
              'version' =>'10000'
          }
      }

      CnpXmlMapper.expects(:request).with(regexp_matches(/.*?<cnpOnlineRequest.*?<sale.*?<applepay>.*?<data>user<\/data>.*?<\/applepay>.*?<\/sale>.*?/m), is_a(Hash))
      CnpOnlineRequest.new.sale(hash)
    end

    # for test the choice functionality
    def test_success_card
      hash = {
          'merchantId' => '101',
          'version'=>'8.8',
          'reportGroup'=>'Planets',
          'cnpTxnId'=>'123456',
          'orderId'=>'12344',
          'amount'=>'106',
          'orderSource'=>'ecommerce',
          'fraudCheck'=>{'authenticationTransactionId'=>'123'}, #for test
          'card'=>{
              'type'=>'VI',
              'number' =>'4100000000000002',
              'expDate' =>'1210'
          }
      }
      CnpXmlMapper.expects(:request).with(regexp_matches(/.*?<cnpOnlineRequest.*?<sale.*?<card>.*?<type>VI<\/type>.*?<\/card>.*?<\/sale>.*?/m), is_a(Hash))
      CnpOnlineRequest.new.sale(hash)
    end

  end
end
