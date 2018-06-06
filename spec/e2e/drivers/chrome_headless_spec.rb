RSpec.describe Superbara do
  describe "drivers" do
    describe "chrome headless" do
      before :all do
        Capybara.default_driver = :chrome_headless
      end

      it "loads" do
        visit "http://www.example.com"
        wait do
          expect(page).to have_content "Example Domain"
        end
      end

      it "sets window size to 1680x1024 by default" do
        #TODO: running locally with different screensizes
        expect([[1680,1024],[1440, 877]]).to include page.current_window.size
      end
    end
  end
end
