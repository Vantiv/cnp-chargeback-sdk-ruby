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
    def setup
      @package_root = Dir.pwd
      @document_to_upload1 = @package_root + "/test/doc.tiff"
      @document_to_upload2 = @package_root + "/test/test.txt"
      @document_to_upload3 = @package_root + "/test/test.jpg"

      open(@document_to_upload1, "w+").close
      open(@document_to_upload2, "w+").close
      open(@document_to_upload3, "w+").close
    end

    def teardown
      File.delete(@document_to_upload1)
      File.delete(@document_to_upload2)
      File.delete(@document_to_upload3)
    end

    def test_retrieve_chargebackDocument
      ChargebackDocument.new.retrieve_document(case_id: "10000000", document_id: "document.jpg", document_path: "test.tiff")
      assert_true(File.exist?("test.tiff"))
      File.delete("test.tiff")
    end

    def test_upload_chargebackDocument
      response = ChargebackDocument.new.upload_document(case_id: "10000", document_path: @document_to_upload3)
      assert_equal('013', response.responseCode)
      assert_equal('Invalid File Content', response.responseMessage)
      assert_equal('test.jpg', response.documentId)
      assert_equal('10000', response.caseId)
    end

    def test_replace_chargebackDocument
      response = ChargebackDocument.new.replace_document(case_id: "10000", document_id: "logo.tiff", document_path: @document_to_upload3)
      assert_equal('013', response.responseCode)
      assert_equal('Invalid File Content', response.responseMessage)
      assert_equal('logo.tiff', response.documentId)
      assert_equal('10000', response.caseId)
    end

    def test_delete_chargebackDocument
      response = ChargebackDocument.new.delete_document(case_id: "10000", document_id: "logo.tiff")
      assert_equal('000', response.responseCode)
      assert_equal('Success', response.responseMessage)
      assert_equal('logo.tiff', response.documentId)
      assert_equal('10000', response.caseId)
    end

    def test_list_chargebackDocument
      response = ChargebackDocument.new.list_documents(case_id: "10000")
      assert_equal('000', response.responseCode)
      assert_equal('Success', response.responseMessage)
      assert_equal('10000', response.caseId)
      document_list = response.documentId
      assert_includes(document_list, "logo.tiff")
      assert_includes(document_list, "doc.tiff")
    end
  end
end
