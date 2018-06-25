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

  class ChargebackDocument
    def initialize
      @config_hash = Configuration.new.config
    end

    def retrieve_document(case_id:, document_id:, document_path:, config: @config_hash)
      request_url =  config['url'] + "/retrieve/" + case_id.to_s + "/" + document_id.to_s
      Communications.http_get_document_request(request_url, document_path, config)
    end

    def upload_document(case_id:, document_path:, config: @config_hash)
      document_id = document_path.split("/")[-1]
      request_url = config['url'] + "/upload/" + case_id + "/" + document_id
      response_xml = Communications.http_post_document_request(request_url, document_path, config)
      return XMLObject.new(response_xml)
    end

    def replace_document(case_id:, document_id:, document_path:, config: @config_hash)
      request_url = config['url'] + "/replace/" + case_id + "/" + document_id
      response_xml = Communications.http_put_document_request(request_url, document_path, config)
      return XMLObject.new(response_xml)
    end

    def delete_document(case_id:, document_id:, config: @config_hash)
      request_url = config['url'] + "/delete/" + case_id + "/" + document_id
      response_xml = Communications.http_delete_document_request(request_url, config)
      return XMLObject.new(response_xml)
    end

    def list_documents(case_id:, config: @config_hash)
      request_url = config['url'] + "/list/" + case_id
      response_xml = Communications.http_get_document_list_request(request_url, config)
      return XMLObject.new(response_xml)
    end



  end
end
