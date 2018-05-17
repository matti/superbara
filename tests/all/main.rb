run "../common", once: true

wait "3" do
  has_text? "Superbara"
end

for feature_path in Dir.glob("tests/features/*.rb") do
  feature_file = "../features/#{File.basename(feature_path)}"

  puts """

RUNNING: #{feature_file}
"""
  run "../features/#{File.basename(feature_path)}"
end
