#!/usr/bin/env ruby

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
NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
=end

# make setup file executable

require 'iostreams'

#
# Configuration generation for URL and credentials
#
class Setup
  attr_reader :handle, :path
  def initialize(filename)
    @handle = File.new(filename, File::CREAT|File::TRUNC|File::RDWR, 0600)
    File.open(filename, 'w') do |f|
      puts 'Welcome to Vantiv eCommerce Ruby_SDK'
      puts 'Please input your user name:'
      f.puts  'user: '+ gets
      puts 'Please input your password:'
      f.puts 'password: ' + gets
      puts 'Please input your merchantId:'
      f.puts 'merchantID: ' + gets
      puts "Please choose Vantiv eCommerce url from the following list (example: 'prelive') or directly input another URL:
sandbox => https://www.testvantivcnp.com/services/chargebacks
prelive => https://payments.vantivprelive.com/services/chargebacks"
      f.puts 'url: ' + Setup.choice(gets)
      puts 'Please input the proxy address, if no proxy hit enter key: '
      f.puts 'proxy_addr: ' + gets
      puts 'Please input the proxy port, if no proxy hit enter key: '
      f.puts 'proxy_port: ' + gets
      f.puts 'printxml: false'
      # default http timeout set to 500 ms
      f.puts 'timeout: 500'
    end
  end

  def finished
    @handle.close
  end

  def Setup.choice(cnp_env)
    if cnp_env == "sandbox\n"
      return 'https://www.testvantivcnp.com/spring/services/chargebacks'
    elsif cnp_env == "prelive\n"
      return 'https://payments.vantivprelive.com/services/chargebacks'
    else
      return 'https://www.testvantivcnp.com/spring/chargebacks'
    end
  end
end

#
#
# Optionally enable the configuration to reside in a custom location
# if the $CNP_CONFIG_DIR directory is set
#

# make the config.yml file in the CNP_CONFIG_DIR directory or HOME directory
if !(ENV['CNP_CONFIG_DIR'].nil?)
  path = ENV['CNP_CONFIG_DIR']
else
  path = ENV['HOME']
end

# make the config.yml file hidden
# create a config file contain all the configuration data
config_file = path + '/.cnp_chargeback_config.yml'
f = Setup.new(config_file)

# return the path of the config file and the path file
@path = File.expand_path(config_file)
puts 'The Vantiv eCommerce configuration file has been generated, the file is located at: ' + @path
f.finished

