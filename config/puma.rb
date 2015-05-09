# Change to match your CPU core count
workers 4

# Min and Max threads per worker
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
temp_dir = "/tmp"

# Default to production
environment "production"

# Set up socket location
bind "unix://#{temp_dir}/kiwi-bnc.sock"

# Logging
stdout_redirect "#{temp_dir}/kiwi-bnc.stdout.log", "#{temp_dir}/kiwi-bnc.stderr.log", true

# Set master PID and state locations
pidfile "#{temp_dir}/kiwi-bnc.pid"
state_path "#{temp_dir}/kiwi-bnc.state"
activate_control_app