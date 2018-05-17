RSpec.describe "cli run" do

  it "opens a file" do
    nano_k = kommando_maker"exe/superbara edit tests/features/find.rb", {
      env: {
        "EDITOR" => "nano"
      },
      timeout: 5
    }
    opened = false

    nano_k.out.once "To Spell" do
      opened = true
      nano_k.in << "\x1B\x1Bx"
    end

    nano_k.run

    expect(opened).to be_truthy
    expect(nano_k.code).to eq 0
  end

  it "opens a directory" do
    nano_k = kommando_maker "exe/superbara edit tests/features", {
      env: {
        "EDITOR" => "nano"
      },
      timeout: 5
    }
    opened = false

    nano_k.out.once '[ "tests/features" is a directory ]' do
      opened = true
      nano_k.in << "\x1B\x1Bx"
    end

    nano_k.run

    expect(opened).to be_truthy
    expect(nano_k.code).to eq 0
  end

end
