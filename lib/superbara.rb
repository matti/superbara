require "io/console"
require "colorize"
require "faker"

require "capybara"
require "capybara/dsl"

require "selenium-webdriver"

require_relative "selenium_monkey"
require_relative "capybara_monkey"
require_relative "pry_monkey"

::Kernel.send :undef_method, :p

require_relative "superbara/config"

module Superbara
  @@project_name = nil
  @@shell = false
  @@current_context = nil
  @@visual = false
  @@started_at = Time.now
  @@project_path = Dir.pwd
  @@config = Superbara::Config.new
  @@errored_runs = []
  @@main = nil

  def self.main=(main)
    @@main=main
  end

  def self.main
    @@main
  end


  def self.start!
    @@started_at = Time.now
  end

  def self.seconds_since_start
    return unless @@started_at
    (Time.now - @@started_at).to_f.round(1)
  end

  def self.shell?
    @@shell
  end

  def self.shell_enable!
    @@shell = true
  end

  def self.shell_disable!
    @@shell = false
  end

  def self.visual?
    return true if @@visual
    return true if ENV["SUPERBARA_VISUAL"]
  end

  def self.visual_disabled(&block)
    env_was_set = if ENV["SUPERBARA_VISUAL"]
      ENV.delete "SUPERBARA_VISUAL"
      true
    end

    visual_was_set = if Superbara.visual?
      self.visual_disable!
      true
    end

    value = block.call

    ENV["SUPERBARA_VISUAL"] = "true" if env_was_set
    Superbara.visual_enable! if visual_was_set

    value
  end

  def self.visual_enable!
    @@visual = true
  end

  def self.visual_disable!
    @@visual = false
  end

  def self.current_context=(ctx)
    @@current_context = ctx
  end

  def self.current_context
    @@current_context
  end

  def self.output(str)
    if Superbara.shell? || Superbara.seconds_since_start.nil?
      puts str
    else
      puts "#{Superbara.seconds_since_start.to_s.ljust(6)} #{str}"
    end
  end

  def self.project_path=(path)
    @@project_path = path
  end

  def self.project_path
    @@project_path
  end

  def self.project_name
    File.basename(@@project_path)
  end

  def self.path
    File.join(File.dirname(__FILE__), "..")
  end

  def self.human_typing_delay
    return unless ENV["SUPERBARA_HUMANIZE"]
    sleep (rand(32) * 0.01).round(2)
  end

  def self.chromedriver_path
    path = File.join(File.expand_path('~'), ".superbara", "chromedriver")
    path << ".exe" if Superbara.platform == "win32"
    path
  end

  def self.platform
    require 'rbconfig'
    cfg = RbConfig::CONFIG
    host_cpu = cfg["host_cpu"]
    host_os = cfg["host_os"]

    platform = case host_os
    when /linux/ then
      if host_cpu =~ /x86_64|amd64/
        "linux64"
      else
        raise "32bit not supported"
      end
    when /darwin/ then "mac64"
    when /mswin/ then "win32"
    when /mingw/ then "win32"
    else
      raise "Unsupported host OS '#{host_os}'"
    end
  end

  def self.errored_runs
    @@errored_runs
  end

  def self.config
    @@config
  end

  def self.toast(text, duration: 1, delay: nil)
    return unless Superbara.visual?

    duration_millis = (duration * 1000).floor
js = """
if (window.__superbaraToastContainerElem) {
  __superbaraToastContainerElem.remove();
  delete(window.__superbaraToastContainerElem);
}

window.__superbaraToastContainerElem = document.createElement('div');
__superbaraToastContainerElem.style.position = 'fixed';
__superbaraToastContainerElem.style.top = '0px';
__superbaraToastContainerElem.style.left = '0px';
__superbaraToastContainerElem.style.height = '100%';
__superbaraToastContainerElem.style.width = '100%';
__superbaraToastContainerElem.style.backgroundColor = 'rgba(0,0,0,0.80)';
__superbaraToastContainerElem.style.display = 'table';
__superbaraToastContainerElem.style.zIndex = '99999999999';
__superbaraToastContainerElem.style.margin = '0';
__superbaraToastContainerElem.style.padding = '0';
__superbaraToastContainerElem.style.border = '0';
__superbaraToastContainerElem.style.borderRadius = '0';
__superbaraToastContainerElem.style.fontSize = '100%';
__superbaraToastContainerElem.style.verticalAlign = 'middle';

var __superbaraToastTextElem = document.createElement('p');
__superbaraToastTextElem.style.display = 'table-cell';
__superbaraToastTextElem.style.verticalAlign = 'middle';
__superbaraToastTextElem.style.textAlign = 'center';

__superbaraToastTextElem.style.fontFamily = 'Helvetica, Arial';

__superbaraToastTextElem.style.fontSize = '4vw';
__superbaraToastTextElem.style.lineHeight = '4vw';
__superbaraToastTextElem.style.color = 'white';

__superbaraToastTextElem.textContent = '#{text}';

__superbaraToastContainerElem.appendChild(__superbaraToastTextElem);

if (window.document.body) {
  window.document.body.appendChild(__superbaraToastContainerElem);

  setTimeout(function() {
    //__superbaraToastContainerElem.remove();
    __superbaraToastContainerElem.style.visibility = 'hidden';
    __superbaraToastContainerElem.style.opacity = 0;
    __superbaraToastContainerElem.style.transition = 'visibility 0s 0.25s, opacity 0.25s linear';
  // delete(window.__superbaraToastContainerElem);
  }, #{duration_millis});
}
"""
    Capybara.current_session.current_window.session.execute_script js
    if delay
      sleep delay
    else
      sleep duration
    end
  end
end

Superbara.main = self

require_relative "superbara/version"
require_relative "superbara/helpers"
require_relative "superbara/chrome"
require_relative "superbara/cli"
require_relative "superbara/context"
require_relative "superbara/web"
require_relative "superbara/errors/not_desired_tag_error"
require_relative "superbara/errors/export_stops_error"

trap "SIGINT" do
  puts "
control+c pressed, closing the browser..."
  begin
    Timeout::timeout(2) do
      Capybara.current_session.driver.browser.close
    end
  rescue Timeout::Error => e
    puts "..browser failed to close within 2 seconds, exiting."
  end
end

Superbara::Chrome.page_load_strategy = "none"

Capybara.default_driver = if ENV["CHROME_URL"]
  :chrome_remote
else
  :chrome
end

Capybara.default_max_wait_time = 0.1

