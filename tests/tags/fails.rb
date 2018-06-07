tag "fails"

unless ENV["SUPERBARA_TAGS"]
  puts "SUPERBARA_TAGS not defined, returning before fail."
  return
end

asdf
