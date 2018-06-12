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

    target_path = File.expand_path '~/.superbara'
    target = File.join target_path, "chromedriver"
    from = File.join Superbara.path, "vendor", "chromedriver", Superbara.platform, "chromedriver"
    if Superbara.platform == "win32"
      from << ".exe"
      target << ".exe"
    end

    File.unlink target if File.exist? target
    FileUtils.mkdir_p target_path
    FileUtils.cp from, target

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
    webapp_thread = nil
    puts "== superbara #{Superbara::VERSION} =="

    loop do
      case main_command
      when "web"
        webapp = Superbara::Web.new port: (ENV['SUPERBARA_WEB_PORT'] || 4567)
        webapp.run!
        exit 0
      when "shell"
        Superbara.visual_enable!
        Superbara.shell_enable!

        unless webapp_thread
          webapp_thread = Thread.new do
            webapp = Superbara::Web.new access_log: false
            webapp.run!
          end
        end


        Superbara::Context::Shell.new "visit 'localhost:4567'"
      when "run", "start"
        puts "project: #{Superbara.project_name}"
        puts ""
        puts "t      action".colorize(:light_black)

        Superbara.start!

        Superbara.visual_disabled do
          Superbara::Context::Eval.new "visit 'about:blank'"
        end

        case main_command
        when "start"
          Superbara.visual_enable!

          Superbara.start_did_open_debug = false
          Superbara::Context::Start.new File.join(Superbara.project_path, project_entrypoint)
          unless Superbara.start_did_open_debug
            puts
            print "WARNING: ".colorize(:yellow)
            puts "your script had a return statement - local variables NOT available in debugger"
            Superbara::Context::Shell.new
          end
        when "run"
          begin
            Superbara::Context::Run.new File.join(Superbara.project_path, project_entrypoint)
          rescue Superbara::Errors::NotDesiredTagError => ex
            test_tags = Marshal.load(ex.message).join(",")
            allowed_tags = Superbara.config.tags.join(",")
            Superbara.output "  ..skipped due to test tags (#{test_tags}) not found in current tags: #{allowed_tags}"
          rescue => ex
            Superbara.print_error ex
            exit 1
          else
            puts """
🏁 🏁 🏁 done."""
          end

          if Superbara.errored_runs.any?
            puts ""
            error_or_errors = if Superbara.errored_runs.size > 1
              "errors"
            else
              "error"
            end

            puts "Run had #{Superbara.errored_runs.size} #{error_or_errors}!".colorize(:red)
            puts ""
            puts "Following runs errored:"
            for errored_run in Superbara.errored_runs
              puts "  #{errored_run}"
            end

            exit 1
          else
            exit 0
          end
        end
      else
        puts "Unknown command: #{main_command}"
        exit 1
      end
    end
  end
end; end
