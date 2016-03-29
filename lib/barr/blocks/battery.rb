module Barr
  module Blocks

    class Battery < Block
      def initialize opts={}
        super
	@showRemaining=opts[:showRemaining] 
      end

      def update
	if @showRemaining == true
	  @output=batNoRem
	else
	  @output=batRem
	end
      end

      def batNoRem
        `acpi | cut -d ',' -f 2-3`
      end
      def batRem
	`acpi | cut -d ',' -f 2`
      end
    end
  end
end
