module Superbara; module Helpers
  def self.highlight_element(elem, styles={}, remove_highlight=100)
    # Yes, could have used a template here.
    js = """
window.__superbara = {};
__superbara.getElementByXpath = function(path) {
return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
};
window.__superbara.highlightElem = window.__superbara.getElementByXpath('#{elem.path}');
window.__superbara.highlightElem.oldStyle = {};
"""
    styles.each_pair do |k,v|
      js << """window.__superbara.highlightElem.oldStyle.#{k} = window.__superbara.highlightElem.style.#{k};
window.__superbara.highlightElem.style.#{k} = '#{v}'
"""
    end

    js << """
window.setTimeout(function() {
  var e = window.__superbara.getElementByXpath('#{elem.path}');
"""
    styles.each_pair do |k,v|
      js << """e.style.#{k} = e.oldStyle.#{k};
"""
    end

    js << """
}, #{remove_highlight})
"""
    Capybara.current_session.current_window.session.execute_script js
  end

end; end
