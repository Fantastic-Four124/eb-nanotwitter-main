# bind "unix:///var/run/puma/my_app.sock"
# pidfile "/var/run/puma/my_app.sock"

workers Integer(ENV['WEB_CONCURRENCY'] || 4)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  $bundle = File.read('bundle.js')
end
