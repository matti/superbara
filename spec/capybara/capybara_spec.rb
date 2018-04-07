RSpec.describe Capybara do
  it "has a version number" do
    expect(Capybara::VERSION).to eq "3.0.0"
  end

  it "sets default_max_wait_time to 1" do
    expect(Capybara.default_max_wait_time).to eq 1
  end
end
