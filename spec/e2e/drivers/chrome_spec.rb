RSpec.describe Superbara do
  describe "drivers" do
    describe "chrome" do
      before :all do
        Capybara.default_driver = :chrome
      end

      it "loads" do
        visit "http://www.example.com"
        expect(page).to have_content "Example Domain"
      end
    end
  end
end
