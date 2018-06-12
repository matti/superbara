module Superbara
  module Context
    class Run < Base
      def initialize(__SUPERBARA_FILE__, __SUPERBARA_PARAMS__={})
        super __SUPERBARA_FILE__, __SUPERBARA_PARAMS__

        Superbara.last_context_return_value = lambda do
          instance_eval """
#{File.read(File.realpath(__SUPERBARA_FILE__))}
""", File.realpath(__SUPERBARA_FILE__), 1
        end.call
      end
    end
  end
end
