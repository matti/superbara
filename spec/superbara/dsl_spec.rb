RSpec.describe Superbara::DSL do
  before :each do
    @dsl = Object.new
    @dsl.extend Superbara::DSL
  end

  describe "debug" do
    it "exists with keyword args" do
      expect(@dsl).to respond_to(:debug).with_keywords(:exception_occurred)
    end
  end

  describe "wait" do
    it "immediately ends" do
      expect {
        @dsl.wait(1) do
          true
        end
      }.to output(/ok.*\(took 0.0s/).to_stdout
    end

    it "ends in timeout when block is false and raises" do
      did_raise = false
      expect {
        begin
          @dsl.wait(0.1) do
            false
          end
        rescue
          did_raise = true
        end
      }.to output(/max 0.1s.*FAIL/).to_stdout
      expect(did_raise).to be_truthy
    end

    it "ends in timeout when block is nil and raises" do
      did_raise = false
      expect {
        begin
          @dsl.wait(0.1) do
            nil
          end
        rescue
          did_raise = true
        end
      }.to output(/max 0.1s.*FAIL/).to_stdout
      expect(did_raise).to be_truthy
    end

    it "ends in timeout when block raises and raises" do
      did_raise = false
      expect {
        begin
          @dsl.wait(0.1) do
            raise
          end
        rescue
          did_raise = true
        end
      }.to output(/max 0.1s.*FAIL/).to_stdout
      expect(did_raise).to be_truthy
    end

    it "tests longer wait time when raise" do
      expect {
        begin
          @dsl.wait(0.1) do
            raise "test more"
          end
        rescue
        end
      }.to output(/testing if waiting for 2 seconds more would help/).to_stdout
    end

    it "tests longer wait time when timeout happens" do
      expect {
        begin
          @dsl.wait(0) do
            sleep 0.5
          end
        rescue
        end
      }.to output(/testing if waiting for 2 seconds more would help/).to_stdout
    end
  end
end
