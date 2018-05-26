run "../common"

def test_file_path(name="test")
  File.join(Superbara.project_path, "#{name}.png")
end

def cleanup(files)
  for path in files
    File.unlink path if File.exist? path
  end
end

cleanup [test_file_path]
screenshot "test"

assert "#{test_file_path} not found" do
  File.exist? test_file_path
end


png_files = Dir.glob(File.join(File.dirname(__FILE__), "*.png"))
cleanup png_files

screenshot

png_files = Dir.glob(File.join(File.dirname(__FILE__), "*.png"))
assert "did not find screenshot" do
  png_files.any?
end
cleanup png_files
