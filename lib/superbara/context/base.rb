module Superbara
  module Context
    class Base
      require_relative "../dsl"
      include Capybara::DSL
      include Superbara::DSL

      def initialize(path_or_contents, params = {})
        params.each_pair do |k,v|
          instance_variable_set "@#{k}", v
        end
      end
    end
  end
end
