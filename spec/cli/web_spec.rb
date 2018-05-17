RSpec.describe "cli run" do

  before :each do
    @web_k = kommando_maker "exe/superbara web", {
      env: {
        "SUPERBARA_WEB_PORT" => "9999"
      },
      timeout: 10
    }
  end

  it "runs" do
    @web_k.run_async
    started = false
    @web_k.out.once 'WEBrick::HTTPServer#start' do
      started = true
    end

    sleep 0.1 until started

    shell_k = kommando_maker "exe/superbara shell", {
      timeout: 10
    }

    shell_k.out.once 'console' do
      shell_k.in.writeln 'visit "localhost:9999"'
    end

    got_request = false
    @web_k.out.once 'GET / HTTP/1.1' do
      got_request = true
      shell_k.in.writeln 'q'
    end

    shell_k.run

    @web_k.kill

    expect(shell_k.code).to eq 0
    expect(got_request).to be_truthy
  end

end
