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

  class Result
    def click_random(highlight: false)
      return unless self.any?

      element = self[rand(self.size)]
      element.highlight if highlight
      element.click
    end
  end
end
