RSpec.describe "example.com" do
  it "has text Example Domain" do
    visit "example.com"

    wait do
      has_text? "Example Domain"
    end
  end
end
