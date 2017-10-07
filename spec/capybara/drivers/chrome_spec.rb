RSpec.describe Capybara do
  describe "drivers" do
    describe "chrome" do
      it "has it" do
        expect(Capybara.drivers[:chrome]).to be_an_instance_of Proc
      end

      it "is the default" do
        expect(Capybara.default_driver).to eq :chrome
      end
    end

    describe "chrome headless" do
      it "has it" do
        expect(Capybara.drivers[:chrome_headless]).to be_an_instance_of Proc
      end
    end
  end
end
