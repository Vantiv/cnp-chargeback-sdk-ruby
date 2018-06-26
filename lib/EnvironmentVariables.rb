module CnpOnline
  class EnvironmentVariables
    def initialize
      # load configuration data
      @user = ''
      @password = ''
      @url = ''
      @proxy_addr = nil
      @proxy_port = nil
      @printxml = false
      @timeout = 65
      @merchantID = ''
    end
  end
end
