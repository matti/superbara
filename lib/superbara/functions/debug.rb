module Superbara
  def self.debug(exception_occurred:false)
    return if ENV['SUPERBARA_FRONTEND'] == "noninteractive"
    debug_help = """
    c - continue to the next debug breakpoint
    s - step to the next line
    r - retry running
    h - help on commands available
    q - exit to shell"""

    debug_header_prefix = "== DEBUG "
    debug_header_suffix = "=" * (IO.console.winsize.last - debug_header_prefix.size)

    puts """
#{debug_header_prefix}#{debug_header_suffix}
#{debug_help}
""".colorize(:light_green)

    $supress_pry_whereami = true if exception_occurred
    Pry.start(binding.of_caller(1))
  end
end