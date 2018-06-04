module Superbara
  module SeleniumMonkey
    module WebDriver
      class Element
        module Includes
          def type(*inputs)
            self.click
            Superbara::Helpers.type *inputs, element: self
          end

          def show(opts={})
            Capybara.execute_script "scrollTo(#{self.location.x}, #{self.location.y-200})"
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
