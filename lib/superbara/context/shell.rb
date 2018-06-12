module Superbara
  module Context
    class Shell < Base
      def initialize(__SUPERBARA_CONTENTS__="", __SUPERBARA_PARAMS__={})
        super __SUPERBARA_CONTENTS__, __SUPERBARA_PARAMS__
        lambda do
          instance_eval """
#{__SUPERBARA_CONTENTS__}
debug disable_whereami: true, help: false
sleep 0.001
"""
        end.call
      end
    end
  end
end
