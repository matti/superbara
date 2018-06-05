RSpec.describe Capybara do
  it "sets default_max_wait_time to 0.1" do
    expect(Capybara.default_max_wait_time).to eq 0.1
  end
end
