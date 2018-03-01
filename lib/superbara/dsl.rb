module Superbara; module DSL
  def wait(seconds, &block)
    Superbara.wait(seconds, &block)
  end

  def debug(exception_occurred: false)
    Superbara.debug(exception_occurred: exception_occurred)
  end
end; end
