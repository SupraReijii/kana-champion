set :application, "kana-champion"
set :repo_url, "git@github.com:SupraReijii/kana-champion.git"
set :rails_env, fetch(:stage)

set :user, "devops"
set :group, "devops"
set :unicorn_user, "devops"

set :rbenv_type, :user
set :rbenv_ruby, File.read(".ruby-version").strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} "\
  "RBENV_VERSION=#{fetch(:rbenv_ruby)} "\
  "RAILS_MASTER_KEY=$(cat /home/#{fetch(:user)}/#{fetch(:application)}/config/master.key) "\
  "/usr/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]

set :nvm_type, :user
set :nvm_node, "v24.21.0"
set :nvm_map_bins, %w{node npm yarn rake}

set :format, :airbrussh
Airbrussh.configure do |airbrussh|
  airbrussh.truncate = false
end

set :log_level, :info

set :branch, ENV["BRANCH"] || "master"




# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
