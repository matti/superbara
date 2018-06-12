hello = "local hello"
@hello = "instance hello"

assert local_variables.inspect do
  local_variables == [:hello, :__SUPERBARA_FILE__, :__SUPERBARA_PARAMS__]
end

assert "instance" do
  instance_variables == [:@hello]
end

"hello from minimal.rb"
