webapp = Superbara::Web.new access_log: false, server_bind: '0.0.0.0'
webapp.run_async!
