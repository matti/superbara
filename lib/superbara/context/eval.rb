module Superbara
  module Context
    class Eval < Base
      def initialize(__SUPERBARA_CONTENTS__, __SUPERBARA_PARAMS__={})
        super __SUPERBARA_CONTENTS__, __SUPERBARA_PARAMS__
        lambda do
          instance_eval __SUPERBARA_CONTENTS__
        end.call
      end
    end
  end
end
