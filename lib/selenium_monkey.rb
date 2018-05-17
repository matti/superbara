module Superbara
  module SeleniumMonkey
    module WebDriver
      class Element
        module Includes
          def type(*inputs)
            def natural_delay
              sleep (rand(32) * 0.01).round(2)
            end

            for input in inputs
              case input
              when String
                input.split("").each do |c|
                  natural_delay
                  self.send_keys c
                end
              when Symbol
                natural_delay
                self.send_keys input
              end
            end
            true
          end

          def show(opts={})
            execute_script "scrollTo(#{self.location.x}, #{self.location.y-200})"
            Superbara::Helpers.highlight_element(self)
          end
        end
      end
    end
  end
end

module Selenium
  module WebDriver
    class Element
      include Superbara::SeleniumMonkey::WebDriver::Element::Includes
    end
  end
end
