module Superbara; module CLI
  def self.run!
    main_command = ARGV[0]

    case main_command
    when "version"
      puts Superbara::VERSION
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

      contents = """visit \"http://example.com\"

wait 3 do
  has_text? \"Example Domain\"
end
click \"h1\"
think 1..3
click \"a\"
scroll 50
"""
      Dir.mkdir project_name
      File.write File.join(project_name, "main.rb"), contents
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

      project_path_expanded = File.expand_path(ARGV[1])

      Superbara.project_path = if Dir.exists? project_path_expanded
        project_path_expanded
      else
        puts "#{project_path_expanded} is not a directory"
        exit 1
      end
    end

    ctx = nil
    webapp_thread = nil
    puts "== superbara #{Superbara::VERSION} =="
    loop do
      Superbara.current_context = Superbara::Context.new(shell: (main_command == "shell"))

      begin
        case main_command
        when "web"
          webapp = Superbara::Web.new
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

          Superbara.current_context.__superbara_eval "visit 'localhost:4567'"
          Superbara.current_context.__superbara_debug
        when "run", "start"
          puts "project: #{Superbara.project_name}"
          puts ""
          puts "t      action".colorize(:light_black)
          Superbara.start!
          Superbara.visual_disable!
          Superbara.current_context.__superbara_eval "visit 'about:blank'"
          Superbara.visual_enable!

          Superbara.current_context.__superbara_load(File.join(Superbara.project_path, "main.rb"))

          puts """
  🏁 🏁 🏁 done."""

          case main_command
          when "run"
            exit 0
          when "start"
            Superbara.current_context.__superbara_debug
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

        Superbara.current_context.__superbara_debug
      end
    end
  end
end; end
