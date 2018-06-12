RSpec.describe "cli run" do

  describe "minimal" do
    before :each do
      @k = kommando_maker "exe/superbara run tests/minimal", {
        timeout: 10
      }
    end

    it "runs" do
      completed = false
      @k.out.once 'run webapp' do
      end.once 'visit http://localhost:4567' do
      end.once 'done.' do
        completed = true
      end
      @k.run

      expect(completed).to be_truthy
      expect(@k.code).to eq 0
    end
  end

  describe "fail" do
    before :each do
      @k = kommando_maker "exe/superbara run tests/fail", {
        timeout: 10
      }
    end

    it "returns to shell with exit status 1" do
      @k.run
      expect(@k.code).to eq 1
    end
  end
end
