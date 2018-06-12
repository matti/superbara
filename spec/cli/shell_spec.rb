RSpec.describe "cli shell" do

  before :each do
    @k = kommando_maker "exe/superbara shell", {
      timeout: 10
    }
  end

  it "opens with localhost" do
    @k.out.once "visit http://localhost:4567" do
    end.once "[ console ]" do
      @k.in.writeln """
e = wait 3 do
  find 'h1'
end
"""
      @k.in.writeln 'e.text'
    end.once "=>" do
    end.once 'Capybara::Node::Element tag="h1" path="/html/body/h1"' do
    end.once "Superbara" do
      @k.in.writeln "q"
    end
    @k.run
    expect(@k.code).to eq 0
  end

  it "visits example.com" do
    @k.out.once "[ console ]" do
      @k.in.writeln "visit 'example.com'"
    end.once "visit http://example.com" do
    end.once "=>" do
    end.once "true" do
      @k.in.writeln "q"
    end
    @k.run
    expect(@k.code).to eq 0
  end
end
