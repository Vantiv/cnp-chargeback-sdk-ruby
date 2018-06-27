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

#
# Used for all transmission to Cnp over HTTP or HTTPS
# works with or without an HTTP proxy
#
# URL and proxy server settings are derived from the configuration file
#

module CnpOnline
  class Communications
    CHARGEBACK_API_HEADERS = {'Accept' => 'application/com.vantivcnp.services-v2+xml',
                               'Content-Type' => 'application/com.vantivcnp.services-v2+xml'}

    CB_DOCUMENT_API_HEADERS = {'Content-Type' => 'image/gif'}

    def self.http_get_document_list_request(request_url, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      req = Net::HTTP::Get.new(url, CB_DOCUMENT_API_HEADERS)
      req.basic_auth(config_hash['user'], config_hash['password'])

      logger.debug "Get request to: " + url.to_s + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      logger.debug http_response.body
      check_response(http_response, config_hash)
      return http_response.body
    end

    def self.http_delete_document_request(request_url, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      req = Net::HTTP::Delete.new(url)
      req.basic_auth(config_hash['user'], config_hash['password'])

      logger.debug "DELETE request to: " + url.to_s + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      logger.debug http_response.body
      check_response(http_response, config_hash)
      return http_response.body
    end


    def self.http_put_document_request(request_url, document_path, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      data, content_type = read_document(document_path)
      req = Net::HTTP::Put.new(url, {'Content-Type' => content_type})
      req.basic_auth(config_hash['user'], config_hash['password'])
      req.body = data

      logger.debug "PUT request to: " + url.to_s + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      logger.debug http_response.body
      check_response(http_response, config_hash)
      return http_response.body
    end

    def self.http_post_document_request(request_url, document_path, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      data, content_type = read_document(document_path)
      req = Net::HTTP::Post.new(url, {'Content-Type' => content_type})
      req.basic_auth(config_hash['user'], config_hash['password'])
      req.body = data

      logger.debug "POST request to: " + url.to_s + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      logger.debug http_response.body
      check_response(http_response, config_hash)
      return http_response.body
    end

    def self.http_get_document_request(request_url, document_path, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      req = Net::HTTP::Get.new(url)
      req.basic_auth(config_hash['user'], config_hash['password'])

      logger.debug "GET request to: " + url.to_s + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      check_response(http_response, config_hash)
      write_document(http_response, document_path, config_hash)
    end

    def self.http_get_retrieval_request(request_url, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      req = Net::HTTP::Get.new(url, CHARGEBACK_API_HEADERS)
      req.basic_auth(config_hash['user'], config_hash['password'])

      logger.debug "GET request to: " + url.to_s + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      logger.debug http_response.body
      check_response(http_response, config_hash)
      return http_response.body
    end

    def self.http_put_update_request(request_url, request_xml, config_hash)
      proxy_addr = config_hash['proxy_addr']
      proxy_port = config_hash['proxy_port']
      url = URI.parse(request_url)
      logger = initialize_logger(config_hash)
      http_response = nil

      https = Net::HTTP.new(url.host, url.port, proxy_addr, proxy_port)
      if url.scheme == 'https'
        https.use_ssl = url.scheme=='https'
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      req = Net::HTTP::Put.new(url, CHARGEBACK_API_HEADERS)
      req.basic_auth(config_hash['user'], config_hash['password'])
      req.body = request_xml

      logger.debug "PUT request to: " + url.to_s + "\n"
      logger.debug request_xml + "\n"

      https.start { |http|
        http_response = http.request(req)
      }

      logger.debug http_response.body
      check_response(http_response, config_hash)
      return http_response.body
    end

    private

    def self.read_document(document_path)
      data = nil
      open(document_path, 'rb') { |f|
        data = f.read
      }
      content_type = nil
      mimemagic = MimeMagic.by_path(document_path)
      if mimemagic
        content_type = mimemagic.type
      end
      return data, content_type
    end

    def self.write_document(http_response, document_path, config_hash)
      content_type = http_response.content_type
      if content_type != "image/tiff"
        raise ("Wrong response content type")
      end
    else
      open(document_path, "wb") do |file|
        file.write(http_response.body)
      end
      puts("\nDocument saved at: ", document_path)
    end

    def self.check_response(http_response, config_hash)
      if http_response == nil
        raise("The response is empty, Please call Vantiv eCommerce")
      end

      if http_response.code != "200"
        puts("\nResponse :" + http_response.body)
        raise("Error with http response, code:" + http_response.header.code)
      end
    end

    def self.initialize_logger(config_hash)
      # Sadly, this needs to be static (the alternative would be to change the CnpXmlMapper.request API
      # to accept a Configuration instance instead of the config_hash)
      Configuration.logger ||= default_logger config_hash['printxml'] ? Logger::DEBUG : Logger::INFO
    end

    def self.default_logger(level) # :nodoc:
      logger = Logger.new(STDOUT)
      logger.level = level
      # Backward compatible logging format for pre 8.16
      logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
      logger
    end
  end
end

=begin
 NOTES ON HTTP TIMEOUT

  Vantiv eCommerce optimizes our systems to ensure the return of responses as quickly as possible, some portions of the process are beyond our control.
  The round-trip time of an Authorization can be broken down into three parts, as follows:
    1.  Transmission time (across the internet) to Vantiv eCommerce and back to the merchant
    2.  Processing time by the authorization provider
    3.  Processing time by Cnp
  Under normal operating circumstances, the transmission time to and from Cnp does not exceed 0.6 seconds
  and processing overhead by Cnp occurs in 0.1 seconds.
  Typically, the processing time by the card association or authorization provider can take between 0.5 and 3 seconds,
  but some percentage of transactions may take significantly longer.

  Because the total processing time can vary due to a number of factors, Vantiv eCommerce recommends using a minimum timeout setting of
  60 seconds to accomodate Sale transactions and 30 seconds if you are not utilizing Sale tranactions.

  These settings should ensure that you do not frequently disconnect prior to receiving a valid authorization causing dropped orders
  and/or re-auths and duplicate auths.
=end