RSpec.describe Capybara do
  it "has a version number" do
    expect(Capybara::VERSION).to eq "2.16.0"
  end

  it "sets default_max_wait_time to 1" do
    expect(Capybara.default_max_wait_time).to eq 1
  end
end
