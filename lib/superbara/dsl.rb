module Superbara; module DSL
  def self.included(includer)
    #puts "Superbara::DSL included in #{includer.inspect}"
  end

  def type(*inputs)
    Superbara::Helpers.type *inputs
  end

  def assert(message=nil, &block)
    failed = if block
      !block.call
    else
      true
    end

    return unless failed

    if message
      Superbara.output ("FAIL: ".colorize(:red) + message)
    else
      Superbara.output "FAIL: ".colorize(:red)
    end

    exit 1
  end

  def screenshot(name=nil)
    name = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{Time.now.hour}-#{Time.now.min}-#{Time.now.sec}" unless name

    filename = if name.end_with? ".png"
      name
    else
      "#{name}.png"
    end

    target_path = File.join(Superbara.project_path, filename)

    sleep 0.1 #magically prevents hangs
    save_screenshot(target_path)
  end

  def back
    Superbara.toast "back", duration: 0.7, delay: 0
    Capybara.go_back
  end

  def forward
    Superbara.toast "forward", duration: 0.7, delay: 0
    Capybara.go_forward
  end

  def reload
    Superbara.toast "reload", duration: 0.7, delay: 0
    Capybara.refresh
  end

  def find(*args)
    value = super *args
    value&.show if Superbara.visual?
    value
  end

  def find_text(text)
    text.downcase!

    js = """
return Array.from(
  document.querySelectorAll('*')
).filter(function(e) {
  return e.textContent.toLowerCase().match('#{text}') ? true : false
}).pop()
"""
    element = Capybara.execute_script js
    element&.show if Superbara.visual?
    element
  end

  def click_text(text)
    find_text(text)&.click
  end

  def click(selector, options={})
    Superbara.output "clicking '#{selector}' with #{options.inspect}"
    e = find selector, options
    e.click
  end

  @@once_runs = []
  def run(what, once: false, **params, &block)
    if once
      if @@once_runs.include? what
        if block
          value = block.call
          return value
        else
          return false
        end
      else
        @@once_runs << what
      end
    end
    Superbara.output "run #{what}"
    Superbara.toast "run #{what}" if Superbara.visual?

    what_expanded = File.expand_path(File.join(Superbara.project_path, what))
    better_what = if Dir.exist? what_expanded
      File.join what_expanded, "main.rb"
    elsif what_expanded.end_with? ".rb"
      what_expanded
    else
      "#{what_expanded}.rb"
    end

    old_project_path = Superbara.project_path
    unless Superbara.project_path == File.dirname(better_what)
      Superbara.project_path = File.dirname(better_what)
    end

    begin
      Superbara.current_context.__superbara_load(better_what, params)
    rescue Exception => ex
      if ENV["SUPERBARA_ON_ERROR"] == "continue"
        colored_output = "  ERROR: ".colorize(:red)
        colored_output << ex.message
        #TODO: output to support "colored tags" and nesting
        Superbara.output colored_output
        Superbara.errored_runs << what
      else
        raise ex
      end
    end
    Superbara.project_path = old_project_path
  end

  def visit(visit_uri_or_domain_or_path)
    uri = ::Addressable::URI.parse(visit_uri_or_domain_or_path)
    current_uri = ::Addressable::URI.parse(Capybara.current_url)

    url_for_capybara = if visit_uri_or_domain_or_path.start_with? "/"
      [current_uri.scheme, "://", current_uri.host, (current_uri.port ? ":#{current_uri.port}" : ""), visit_uri_or_domain_or_path].join("")
    elsif ["http", "https", "about"].include? uri.scheme
      visit_uri_or_domain_or_path
    else
      "http://#{visit_uri_or_domain_or_path}"
    end

    Superbara.output "visit #{url_for_capybara}"
    Superbara.toast "#{url_for_capybara}", delay: 1 if Superbara.visual?

    Capybara.visit url_for_capybara

    true # capybara returns nil
  end

  def atleast(range)
    min = range.to_a.first
    add = rand(range.to_a.last)
    min+add
  end

  def think(range)
    duration = atleast(range)

    Superbara.output "think #{duration}s"
    if Superbara.visual?
      Superbara.toast "hmm...", delay: duration
    else
      sleep duration
    end
  end

  @@focused_once = false
  def focus(once: false)
    if once
      return false if @@focused_once
      @@focused_once = true
    end

    Capybara.page.switch_to_window Capybara.current_window
  end

  def scroll(percentage, duration: 0.4)
    begin
      outer_height = Capybara.current_session.current_window.session.execute_script "return document.body.scrollHeight"
    rescue Selenium::WebDriver::Error::UnknownError => ex
      sleep 0.1
      retry
    end

    scroll_y = outer_height / 100 * percentage

    scrolls = (duration / 0.1).floor
    amount = (scroll_y / scrolls).ceil
    Superbara.output "scrolling #{percentage}%"
    scrolls.times do
      Capybara.current_session.current_window.session.execute_script "window.scrollBy(0,#{amount})"
      sleep 0.09
    end
    true
  end

  def tag(*tags, &block)
    tags.flatten!

    desired = if Superbara.config.tags.empty?
      true
    else
      found = false
      for tag in tags do
        if Superbara.config.tags.include? tag
          found = true
          break
        end
      end

      found
    end

    if desired
      if block.nil?
        return
      else
        value = block.call
        return value
      end
    else
      raise Superbara::Errors::NotDesiredTagError
    end
  end

  def wait(seconds=5, &block)
    def wait_formatted_output(status, took_delta)
      word, color = if status
        ["ok", :green]
      else
        ["FAIL", :red]
      end

      Superbara.output "  #{word.colorize(color)} (took #{(took_delta)}s)"
    end

    seconds = seconds.to_f
    source_path, source_line = block.source_location

    Superbara.output "waiting max #{seconds}s for:"
    case source_path
    when "(pry)"
      Superbara.output "    [dynamic code]".colorize(:light_black)
    else
      open(source_path).each_with_index do |line, i|
        next if i < source_line
        break if line.start_with? "end"
        formatted_line = line.gsub("\n", "").lstrip
        Superbara.output "  #{formatted_line}".colorize(:light_black)
      end
    end

    started_at = Time.now
    previous_capybara_default_max_wait_time = Capybara.default_max_wait_time
    block_value = nil
    exception = nil
    timed_out = false
    begin
      Capybara.default_max_wait_time = seconds
      Timeout::timeout (seconds+0.1) do
        loop do
          block_value = block.call
          case block_value
          when false, nil, []
            sleep 0.1
          else
            break
          end
        end
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
      previous_default_max_wait_time = Capybara.default_max_wait_time
      puts "  testing if waiting for 2 seconds more would help.."
      begin
        Timeout::timeout(2.1) do
          Capybara.default_max_wait_time = 2
          additional_block_value = block.call
        end
      rescue Exception => ex
        additional_exception = ex
      ensure
        Capybara.default_max_wait_time = previous_default_max_wait_time
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

  def debug(exception_occurred:false, disable_whereami: false, help: true)
    return if ENV['SUPERBARA_FRONTEND'] == "noninteractive"
    Superbara.shell_enable!
    Superbara.visual_enable!

    debug_help = """
    c - continue to the next debug breakpoint
    s - step to the next line
    r - retry running
    h - help on commands available
    q - exit to shell"""

    debug_header_prefix = "== DEBUG "
    debug_header_suffix = "=" * (IO.console.winsize.last - debug_header_prefix.size).abs

    if help
      puts """
#{debug_header_prefix}#{debug_header_suffix}
#{debug_help}
""".colorize(:light_green)
    end

    $__superbara_supress_pry_whereami = true if exception_occurred || disable_whereami
    Pry.start(binding.of_caller(1))
  end
end; end

extend Capybara::DSL
extend Superbara::DSL  # override Capybara methods
