RSpec.describe "cli run" do

  before :each do
    @k = kommando_maker "exe/superbara version", {
      timeout: 3
    }
  end

  it "prints version" do
    @k.run
    expect(@k.out).to eq "#{Superbara::VERSION}\r\n"
    expect(@k.code).to eq 0
  end

end
