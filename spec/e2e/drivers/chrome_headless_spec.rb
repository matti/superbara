RSpec.describe Superbara do
  describe "drivers" do
    describe "chrome headless" do
      before :all do
        Capybara.default_driver = :chrome_headless
      end

      it "loads" do
        visit "http://www.example.com"
        expect(page).to have_content "Example Domain"
      end
    end
  end
end
