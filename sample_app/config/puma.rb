# Puma configuration file for the application.

# Set up Puma to handle a configurable number of threads per worker.
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 2 }
threads threads_count, threads_count

# Set the port that Puma will listen on to receive requests (default is 3000).
port ENV.fetch("PORT") { 3000 }

# Set the environment in which Puma will operate.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the number of worker processes. For Render's free tier, a single worker is recommended.
workers ENV.fetch("WEB_CONCURRENCY") { 1 }

# Preloading the application is disabled to conserve memory in limited environments.
# preload_app!

# Allows Puma to be restarted by the `bin/rails restart` command.
plugin :tmp_restart

# Specify the PID file to track Puma processes. Default is in `tmp/pids/server.pid`.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Additional configuration for production environments:
# Before forking, disconnect the database connection. This prevents sharing connections
# across multiple processes, ensuring each worker has its own connection.
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
