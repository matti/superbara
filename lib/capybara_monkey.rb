module Capybara
  module Node
    class Element
      def highlight
        for color in ["DeepPink", "GreenYellow", "Aqua", "Red", "Yellow"]
          Superbara::Helpers.highlight_element(self, {color: color})
          sleep 0.1
        end
        "did you see it?"
      end
    end
  end
end
