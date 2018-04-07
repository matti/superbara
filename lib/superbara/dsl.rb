module Superbara; module DSL
  def self.included(includer)
    puts "Superbara::DSL included in #{includer.inspect}"
  end

  def atleast(range)
    min = range.to_a.first
    add = rand(range.to_a.last)
    min+add
  end
  def think(range)
    duration = atleast(range)

    Superbara.puts "thinking #{duration}s"
    sleep duration
  end

  def wait(seconds, &block)
    def wait_formatted_output(status, took_delta)
      word, color = if status
        ["ok", :green]
      else
        ["FAIL", :red]
      end

      puts "#{word.colorize(color)} (took #{(took_delta)}s)"
    end
    seconds = seconds.to_f

    print "--> waiting max #{seconds}s "
    started_at = Time.now

    previous_capybara_default_max_wait_time = Capybara.default_max_wait_time
    block_value = nil
    exception = nil
    timed_out = false
    begin
      Capybara.default_max_wait_time = seconds
      Timeout::timeout (seconds+0.1) do
        block_value = block.call
      end
    rescue Timeout::Error => ex
      timed_out = true
    rescue Exception => ex
      exception = ex
    end

    took_delta = (Time.now - started_at).floor(2)
    Capybara.default_max_wait_time = previous_capybara_default_max_wait_time

    if exception || timed_out
      wait_formatted_output false, took_delta

      additional_started_at = Time.now
      additional_block_value = nil
      additional_exception = nil
      puts "  testing if waiting for 2 seconds more would help.."
      begin
        Capybara.default_max_wait_time = 2
        additional_block_value = block.call
      rescue Exception => ex
        additional_exception = ex
      end
      additional_took_delta = (Time.now - additional_started_at).floor(2)
      suggested_wait_value = (seconds + additional_took_delta).floor(2)

      if additional_exception || additional_block_value.nil?
        puts "  ..did not help."
      else
        puts "  ..setting wait to >#{suggested_wait_value} would help here?"
      end

      if exception
        raise exception
      else
        raise "capybara timed out"
      end
    end

    if block_value == false
      wait_formatted_output false, took_delta
      raise "wait condition was falsy"
    end

    if block_value == nil
      wait_formatted_output false, took_delta
      raise "wait condition was nil"
    end

    self.wait_formatted_output true, took_delta
    return block_value
  end

  def debug(exception_occurred:false)
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
end; end

include Superbara::DSL
include Capybara::DSL
