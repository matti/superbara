require "pry-byebug"
require "binding_of_caller"

class Pry
  class Command::Whereami < Pry::ClassCommand
    alias_method :process_orig, :process
    def process
      if $supress_pry_whereami
        $supress_pry_whereami = false
        puts ""
        nil
      else
        process_orig
      end
    end
  end
end

Pry.config.prompt = proc {
  prefix = "\n==[ console ]== (".colorize(:black).on_white

  prefix << "r".colorize(:light_blue).on_white.underline
  prefix << "estart, ".colorize(:black).on_white

  prefix << "c".colorize(:light_blue).on_white.underline
  prefix << "ontinue, ".colorize(:black).on_white

  prefix << "e".colorize(:light_blue).on_white.underline
  prefix << "dit, ".colorize(:black).on_white

  prefix << "h".colorize(:light_blue).on_white.underline
  prefix << "elp, ".colorize(:black).on_white

  prefix << "q".colorize(:light_blue).on_white.underline
  prefix << "uit".colorize(:black).on_white

  prefix << ") ".colorize(:black).on_white
  prefix << "\n"
  print prefix

  ""
}

Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'
Pry.commands.alias_command 'h', 'help'

Pry::Commands.command /^e$/, "edit" do
  puts "Opening #{$superbara_current_file} ..."
  begin
    `superbara edit #{$superbara_current_file}`
  rescue Exception => ex
    puts "[development mode edit]"
    `exe/superbara edit #{$superbara_current_file}`
  end
end

Pry::Commands.command /^help$/, "help" do

  capybara_help_help = '''
  e = find "h1", text: "Example Domain"
  e = find "h1", text: /xample Dom/
  e.click

  e = wait 2 do
    find "p", text: "Added to the cart"
  end
  e.click

  more: https://github.com/teamcapybara/capybara#the-dsl'''

  capybara_help_header_prefix = "== HELP "
  capybara_help_header_suffix = "=" * (IO.console.winsize.last - capybara_help_header_prefix.size)

  puts """
#{capybara_help_header_prefix}#{capybara_help_header_suffix}
#{capybara_help_help}
""".colorize(:light_green)
end

Pry::Commands.command /^q$/, "abort" do
  exit 1
end

Pry::Commands.command /^r$/, "retry" do
  exit 2
end

Pry::Commands.command /^$/, "repeat last command if stepping" do
  last_command = Pry.history.to_a.last

  if ["next", "n", "step", "s", "continue", "c"].include? last_command
    _pry_.run_command last_command
  end
end
