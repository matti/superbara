module Superbara; module Helpers
  def self.type(*inputs, element:nil)
    for input in inputs
      case input
      when String
        if input == "" && element
          element.clear
        else
          input.split("").each do |c|
            Superbara.human_typing_delay
            Capybara.page.driver.browser.action.send_keys(c).perform
          end
        end
      when Symbol
        Superbara.human_typing_delay
        Capybara.page.driver.browser.action.send_keys(input).perform
      end

      sleep 0.5 # without this events might not get sent properly
    end

    true
  end

  def self.highlight_element(elem, styles={}, remove_highlight=0.1)
    remove_highlight_millis = (1000 * remove_highlight).round

    js = if elem.class == Selenium::WebDriver::Element
      """
var __superbaraShowElem = document.createElement('p');
__superbaraShowElem.style.position = 'fixed';
__superbaraShowElem.style.top = '#{elem.location.y-10}px';
__superbaraShowElem.style.left = '#{elem.location.x}px';
__superbaraShowElem.style.color = 'white';
__superbaraShowElem.style.backgroundColor = 'red';
__superbaraShowElem.style.zIndex = '99999999999';
__superbaraShowElem.textContent = 'XXXXX';

window.document.body.appendChild(__superbaraShowElem);

window.setInterval(function() {
  __superbaraShowElem.remove();
}, #{remove_highlight_millis});
"""
    else
      js_builder = """
window.__superbara = {};
__superbara.getElementByXpath = function(path) {
return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
};
window.__superbara.highlightElem = window.__superbara.getElementByXpath('#{elem.path}');
if (!window.__superbara.highlightElem) {
  return;
}

window.__superbara.highlightElem.oldStyle = {};
"""
      styles.each_pair do |k,v|
        js_builder << """window.__superbara.highlightElem.oldStyle.#{k} = window.__superbara.highlightElem.style.#{k};
window.__superbara.highlightElem.style.#{k} = '#{v}'
"""
      end

      js_builder << """
window.setTimeout(function() {
  var e = window.__superbara.getElementByXpath('#{elem.path}');
"""
      styles.each_pair do |k,v|
        js_builder << """e.style.#{k} = e.oldStyle.#{k};
"""
      end

      js_builder << """
}, #{remove_highlight_millis})
"""
      js_builder
    end

    Capybara.execute_script js
    sleep remove_highlight
  end
end; end
