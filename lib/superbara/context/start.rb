module Superbara
  module Context
    class Start < Base
      def initialize(__SUPERBARA_FILE__, __SUPERBARA_PARAMS__={})
        super __SUPERBARA_FILE__, __SUPERBARA_PARAMS__

        lambda do
          instance_eval """
begin
  #{File.read(File.realpath(__SUPERBARA_FILE__))}
rescue Superbara::Errors::NotDesiredTagError
  Superbara.print_tag_skip $!
rescue
  Superbara.print_error $!
else
  puts '
🏁 🏁 🏁 done.'
end

debug disable_whereami: true, help: false
sleep 0.001
""",
          File.realpath(__SUPERBARA_FILE__),
          1
        end.call
      end
    end
  end
end


