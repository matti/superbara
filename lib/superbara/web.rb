require 'sinatra/base'

module Superbara; class Web
  def initialize(access_log: true, server_bind: '127.0.0.1')
    @webapp = Sinatra.new do
      root_path = File.join(File.dirname(__FILE__), "..", "..", "web")

      unless access_log
        set :server_settings, :AccessLog=>[]
      end

      set :bind, server_bind
      set :root, root_path

      get '/' do
        File.read(File.join(root_path,"public", "index.html"))
      end

      get '/__superbara/:feature' do
        erb params[:feature].to_sym
      end
    end
  end

  def run!
    @webapp.run!
  end

  def run_async!
    Thread.new do
      self.run!
    end
  end
end; end
