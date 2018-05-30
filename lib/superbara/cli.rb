module Superbara; module CLI
  def self.run!
    require 'superbara/dsl'
    main_command = ARGV[0]

    case main_command
    when "version"
      puts Superbara::VERSION
      exit 0
    when "edit"
      editor_cmd = if ENV["SUPERBARA_EDITOR"]
        ENV["SUPERBARA_EDITOR"]
      elsif ENV["EDITOR"]
        ENV["EDITOR"]
      else
        'open'
      end

      dir_or_file = ARGV[1]

      puts "Opening #{dir_or_file} with #{editor_cmd} .."

      if editor_cmd == "nano"
        exec "#{editor_cmd} #{dir_or_file}"
      else
        `#{editor_cmd} #{dir_or_file}`
      end

      exit 0
    when "web", "shell"
      #
    when "init"
      project_name = ARGV[1]
      unless project_name
        puts "project name missing"
        exit 1
      end

      if Dir.exists? project_name
        puts "directory #{project_name} already exists"
        exit 1
      end

      contents = """visit 'example.com'

wait 3 do
  has_text? 'Example Domain'
end

think 1..3

click 'a'
scroll 50
"""
      Dir.mkdir project_name
      File.write File.join(project_name, "main.rb"), contents

      puts "Created directory #{project_name} with main.rb"
      puts "Start testing with:"
      puts ""
      puts "  superbara start #{project_name}"
      exit 0
    else
      unless ARGV[1]
        puts """USAGE:

  superbara init <dir>    - initialize a test directory

  superbara run <dir>     - run a test
  superbara start <dir>   - run a test and start development mode
  superbara shell         - interactive mode with built-in web server

  superbara web           - start the built-in web server
  superbara edit <dir>    - edit directory with $EDITOR
"""
        exit 1
      end
    end

    case main_command
    when "start", "run"
      project_path_or_file_expanded = File.expand_path(ARGV[1])

      Superbara.project_path, project_entrypoint = if Dir.exists? project_path_or_file_expanded
        unless File.exist? File.join(project_path_or_file_expanded, "main.rb")
          puts "No main.rb found in #{project_path_or_file_expanded}"
          puts "Alternatively you can also specify the file name."
          exit 1
        end
        [project_path_or_file_expanded, "main.rb"]
      elsif File.exists? project_path_or_file_expanded
        [
          File.dirname(project_path_or_file_expanded),
          File.basename(project_path_or_file_expanded)
        ]
      else
        puts "#{project_path_or_file_expanded} is not a directory or a file"
        exit 1
      end
    end
    Pry.start if ENV['SUPERBARA_DEBUG']
    ctx = nil
    webapp_thread = nil
    puts "== superbara #{Superbara::VERSION} =="
    loop do
      Superbara.current_context = Superbara::Context.new

      begin
        case main_command
        when "web"
          webapp = Superbara::Web.new port: (ENV['SUPERBARA_WEB_PORT'] || 4567)
          webapp.run!
          exit 0
        when "shell"
          Superbara.visual_enable!
          Superbara.shell_enable!
          Superbara::Chrome.page_load_strategy = "none"

          unless webapp_thread
            webapp_thread = Thread.new do
              webapp = Superbara::Web.new access_log: false
              webapp.run!
            end
          end
          # to make debugger work (TODO)
          extend Capybara::DSL
          extend Superbara::DSL
          Superbara.current_context.__superbara_eval "visit 'localhost:4567'"
          Superbara.current_context.__superbara_debug # <-- ONLY WORKS WITH THIS??? TODO
          exit 0
        when "run", "start"
          puts "project: #{Superbara.project_name}"
          puts ""
          puts "t      action".colorize(:light_black)
          Superbara.start!
          Superbara.visual_disabled do
            Superbara.current_context.__superbara_eval "visit 'about:blank'"
          end

          case main_command
          when "start"
            Superbara.visual_enable!
          end

          Superbara.current_context.__superbara_load File.join(Superbara.project_path, project_entrypoint)
          puts """
  🏁 🏁 🏁 done."""

          case main_command
          when "run"
            exit 0
          when "start"
            Superbara.current_context.__superbara_eval """
debug disable_whereami: true, help: false;
sleep 0.0001
            """
          end
        else
          puts "Unknown command: #{main_command}"
          exit 1
        end
      rescue Exception => ex
        return if ex.class == SystemExit

        begin
          offending_file_path_and_line_in_this = ex.backtrace.detect { |line| line.end_with?("`<top (required)>'") }
          offending_file_path, offending_line, _ = offending_file_path_and_line_in_this.split(":")
          offending_code = IO.readlines(offending_file_path)[offending_line.to_i-1]
        rescue Exception => ex_while_parsing
          raise ex
        end
        puts """
== Exception ==""".colorize(:red)
        puts """#{ex.class}
#{ex.message}
in #{offending_file_path}:#{offending_line}
#{offending_line}: #{offending_code}""".colorize(:light_black)

        case main_command
        when "start"
          Superbara.current_context.instance_eval  """debug disable_whereami: true, help: false
sleep 0.001
"""
        else
          exit 1
        end
      end
    end
  end
end; end
