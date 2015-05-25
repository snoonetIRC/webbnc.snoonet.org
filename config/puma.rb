workers 4
threads 1, 6
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "/tmp/kiwi-bnc"
daemonize true
environment "production"
bind "unix://#{shared_dir}/sockets/puma.sock"
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app