require 'fileutils'

RSpec.describe "cli run" do

  before :each do
    @k = kommando_maker "exe/superbara init __test", {
      timeout: 3
    }
  end

  before :each do
    FileUtils.rm_rf "__test"
  end

  after :each do
    FileUtils.rm_rf "__test"
  end

  it "runs" do
    expect(Dir.exist?("__test")).to be_falsy
    @k.run
    expect(Dir.exist?("__test")).to be_truthy

    expect(@k.code).to eq 0
  end

  it "can be ran from newly created dir" do
    @k.run
    new_k = kommando_maker "exe/superbara run __test", {
      timeout: 30
    }
    completed = false
    new_k.out.once("done.") do
      completed = true
    end
    new_k.run

    expect(completed).to be_truthy
    expect(new_k.code).to eq 0
  end

end
