RSpec.describe Superbara do
  describe "drivers" do
    describe "chrome headless" do
      before :all do
        Capybara.default_driver = :chrome_headless
      end

      it "loads" do
        visit "http://localhost:8000/index.html"
        expect(page).to have_content "Superbara"
      end

      it "sets window size to 1680x1024 by default" do
        expect(page.current_window.size).to eq [1680,1024]
      end
    end
  end
end
