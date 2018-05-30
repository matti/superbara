RSpec.describe Superbara do
  describe "drivers" do
    describe "chrome" do
      before :all do
        Capybara.default_driver = :chrome
      end

      it "loads" do
        visit "http://www.example.com"
        wait 5 do
          has_text? "Example Domain"
        end
        expect(page).to have_content "Example Domain"
      end

      it "sets window size to 1680x1024 by default" do
        expect(page.current_window.size).to eq [1680,1024]
      end
    end
  end
end
