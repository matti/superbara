require "pry-byebug"
require "binding_of_caller"

module Superbara
  module PryMonkey
    class Command
      class Exit < Pry::ClassCommand
        module Prepends
          def process
            Superbara.shell_disable!
            Superbara.visual_disable!
            super
          end
        end
      end

      class Whereami < Pry::ClassCommand
        module Prepends
          def process
            if $__superbara_supress_pry_whereami
              $__superbara_supress_pry_whereami = false
              puts ""
              nil
            else
              super
            end
          end
        end
      end
    end
  end
end

class Pry
  class Command::Exit < Pry::ClassCommand
    prepend ::Superbara::PryMonkey::Command::Exit::Prepends
  end
  class Command::Whereami < Pry::ClassCommand
    prepend ::Superbara::PryMonkey::Command::Whereami::Prepends
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
  puts "Opening #{Superbara.project_path} ..."
  `superbara edit #{Superbara.project_path}`
end

Pry::Commands.command /^help$/, "help" do
  capybara_help_help = '''
  e = find "h1"
  e = find "h1", text: /xample Dom/
  e.click

  e = wait 2 do
    find "span", text: "Added to the cart"
  end
  e.click

  think 2..4
  scroll 50
  scroll -10, duration: 4
  focus

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
  _pry_.run_command "exit"
end

Pry::Commands.command /^$/, "repeat last command if stepping" do
  last_command = Pry.history.to_a.last

  if ["next", "n", "step", "s", "continue", "c"].include? last_command
    _pry_.run_command last_command
  end
end
