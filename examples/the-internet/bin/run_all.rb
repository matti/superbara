require "kommando"

files = Dir.glob("*.rb")
files = files - ["slow.rb"]
files.shuffle!

for file in files
  k = Kommando.new "superbara run #{file}", output: true
  done = false
  k.out.once /🏁/ do
    done = true
    k.in.writeln "q"
  end

  k.run_async
  loop do
    break if done
    sleep 0.1
  end
end
