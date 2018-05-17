module Superbara; class Context

  def initialize(shell: false)
    @__superbara_shell = shell
    @__superbara_binding = binding
    @__superbara_binding.eval """
require 'superbara/dsl'
"""
  end

  def __superbara_debug
    __superbara_eval """
debug disable_whereami: true, help: false
sleep 0.0001
"""
  end

  def __superbara_load(path)
    load path
  end

  def __superbara_eval(str)
    @__superbara_binding.eval str
  end

  def method_missing(m, *args, &block)
    super unless Superbara.shell?

    selector = m.to_s
    finder_args = args[0] if args.any?

    would_find_size = evaluate_script "document.querySelectorAll('#{m}').length"
    if would_find_size > 50
      puts "tried to find with selector '#{m}', but would return over 50 elements (#{would_find_size}) and hang."
      return false
    end

    print "finding all '#{m}'"

    results = if finder_args
      puts " #{finder_args}"
      all selector, finder_args
    else
      puts ""
      all selector
    end

    if results.size == 1
      results.first.show
    elsif results.size > 1
      results.show(styles: [{"border" =>  "20px dashed Red"}])
    else
      []
    end
  end

end; end
