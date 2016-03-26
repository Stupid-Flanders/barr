module Barr
  module Blocks
    class Ip < Block

      attr_reader :device
      
      def initialize opts={}
        super
        @device = opts[:device] || "192"
      end

      def update
        ip, dev = `ip addr | grep #{@device} | tail -n1 | awk '{printf "%s %s", $2, $8}'`.chomp.split(" ")
        ip = ip.split("/")[0]                                                                             
        
        @output = "#{dev} > #{ip}"                                                                        
      end
      
    end
  end
end
