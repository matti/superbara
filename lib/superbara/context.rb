module Superbara; class Context
  require_relative "dsl"
  include Capybara::DSL
  include Superbara::DSL

  def initialize
    @__superbara_binding = binding
  end

  def __superbara_debug
    __superbara_eval """
debug disable_whereami: true, help: false
sleep 0.0001
"""
  end

  def __superbara_load(path, params={})
    params.each_pair do |k,v|
      Superbara.main.define_singleton_method k.to_sym do
        v
      end
    end

    begin
      load path, true
    rescue Superbara::Errors::NotDesiredTagError
      Superbara.output "  ..skipped due to tag not found"
    end

    params.each_pair do |k,v|
      Superbara.main.instance_eval "undef #{k.to_sym}"
    end
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
