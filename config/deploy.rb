require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.


set :application, 'diplomacy'

set :rails_env, 'production'
#set :domain, 'mkonin@137.117.230.217'
set :domain, 'mkonin@185.4.75.151'
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :normalize_asset_timestamps, false
set :keep_releases, 5

set :rvm_ruby_string, 'ruby-2.0.0-p247'


set :scm, :git
set :repository, 'https://github.com/vonagam/dip.git'
set :branch, 'master' # Ветка из которой будем тянуть код для деплоя.
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'
after 'deploy:update', 'deploy:cleanup'

# Generate an additional task to fire up the thin clusters
namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd #{deploy_to}/current; bundle exec thin start -C config/thin.yml
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd #{deploy_to}/current; bundle exec thin stop -C config/thin.yml
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd #{deploy_to}/current; bundle exec thin restart -C config/thin.yml
    CMD
  end
  task :init_vhost do
    run "ln -s #{deploy_to}/current/config/#{application}.vhost /etc/nginx/sites-enabled/#{application}"
  end


end



namespace :things_going do
  task :start do
    run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=#{rails_env} websocket_rails:start_server"
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bin/delayed_job start"
  end

  task :stop do
    run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=#{rails_env} websocket_rails:stop_server"
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bin/delayed_job stop"
  end

  task :restart do
    run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=#{rails_env} websocket_rails:stop_server"
    run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=#{rails_env} websocket_rails:start_server"
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bin/delayed_job restart"
  end
end

after 'deploy', 'things_going:restart'
