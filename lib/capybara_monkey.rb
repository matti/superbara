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
    def click_random(highlight: false, once: true)
      unless self.any?
        Superbara.puts "no elements in collection"
        return false
      end

      index = if once
        @__superbara_clicked ||= []
        if @__superbara_clicked.size == self.size
          Superbara.puts "no unclicked elements left, not clicking anything"
          return false
        end

        selected_index = nil
        possible_index = nil
        loop do
          possible_index = rand(self.size)
          next if @__superbara_clicked.include? possible_index
          selected_index = possible_index
          @__superbara_clicked << selected_index
          break
        end

        selected_index
      else
        rand(self.size)
      end

      element = self[index]
      element.highlight if highlight
      Superbara.puts "clicking index: #{index} out of #{self.size}"
      element.click
    end
  end
end
