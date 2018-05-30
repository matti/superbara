module Superbara
  module CapybaraMonkey
    module Node
      class Element
        module Includes
          def show(styles: nil, remove_highlight: 0.1)
            Capybara.execute_script "scrollTo(#{self.native.location.x}, #{self.native.location.y-200})"
            styles = [
                {
                  "border" =>  "20px dashed Aqua"
                }
              ] unless styles

            for style in styles
              Superbara::Helpers.highlight_element(self, style, remove_highlight)
              if styles.size > 1
                sleep 0.05
              end
            end

            self
          end

          def type(*inputs)
            self.native.type(*inputs)
          end

        end #Includes

        module Prepends
          def click(*keys, **offset)
            if Superbara.visual?
              sleep 0.1
              self.show(styles: [{"border" =>  "10px dashed GreenYellow"}], remove_highlight: 0.1)
            end
            Superbara.output "click #{self.tag_name} '#{self.text}'"
            super *keys, **offset
          end
        end
      end #Element
    end #Node

    class Result
      module Includes
        def second
          self[1]
        end
        def third
          self[2]
        end
        def fourth
          self[3]
        end
        def fifth
          self[4]
        end
        # active support stops herew
        def sixth
          self[5]
        end
        def seventh
          self[6]
        end
        def eight
          self[7]
        end
        def ninth
          self[8]
        end
        def tenth
          self[9]
        end
        # also
        def random
          self[rand(self.size)]
        end
        def middle
          self[self.size/2]
        end

        def show(styles=nil)
          for e in self
            e.show styles
          end
          self
        end

        def click_random(show: false, once: true)
          unless self.any?
            return false
          end

          index = if once
            @__superbara_clicked ||= []
            if @__superbara_clicked.size == self.size
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
          element.show if show
          element.click
        end
      end #Includes
    end #Result
  end #Capybara
end #Superbara

module Capybara
  module DSL
    def self.included(base)
      #warn "including Capybara::DSL in the global scope is not recommended!" if base == Object
      #super
    end
    def self.extended(base)
      #warn "extending the main object with Capybara::DSL is not recommended!" if base == Object
      #super
    end
  end

  module Node
    class Element
      include Superbara::CapybaraMonkey::Node::Element::Includes
      prepend Superbara::CapybaraMonkey::Node::Element::Prepends
    end
  end

  class Result
    include Superbara::CapybaraMonkey::Result::Includes
  end
end
