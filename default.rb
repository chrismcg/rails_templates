# Rails with rpsec 3, capybara, guard, dotenv, bootstrap, puma, foreman

######### Initial Skeleton

run "bundle install"

git :init
git add: "."
git commit: %Q{ -m "Initial skeleton" }

######### Database Config

# Remove production from database config
run "sed -i '' '/^production:/,$d' config/database.yml"

rake "db:create:all"
rake "db:migrate"

git add: "."
git commit: %Q{ -m "Database configuration" }

######## Remove turbolinks

run "sed -i '' '/require turbolinks/d' app/assets/javascripts/application.js"
run "sed -i '' '/turbolinks/d' Gemfile"

git add: "."
git commit: %Q{ -m "Remove turbolinks" }

######### Set ruby version

run "echo #{RUBY_VERSION} >> .ruby-version"
run 'sed -i \'\' \'s/^source.*$/&\
ruby File.read(File.expand_path("..\/.ruby-version", __FILE__)).chomp/\' Gemfile'

git add: "."
git commit: %Q{ -m "Set ruby version to #{RUBY_VERSION}" }

######### Utilities

gem "pry-rails"
gem_group :development, :test do
  gem "dotenv-rails"
end

run "bundle install"

git add: "."
git commit: %Q{ -m "Add utility gems" }

######### Webserver

gem "puma"
run "bundle install"
run "cp #{File.join(File.dirname(__FILE__), 'webserver_config', 'puma.rb')} config/puma.rb"

# Configure dev for just one worker
run "echo 'PUMA_WORKERS=1' >> .env"

# Configure foreman
run "echo 'web: bundle exec puma --config config/puma.rb' >> Procfile"

git add: "."
git commit: %Q{ -m "Add Puma" }

######### Testing

gem_group :development, :test do
  gem "spring-commands-rspec"
  gem "rspec-rails"
  gem "capybara"
end

run "bundle install"
generate "rspec:install"
run "spring binstub --all"

# filter out =begin and =end in rspec helper to get the defaults
run "sed -E -i '' '/=(begin|end)/d' spec/spec_helper.rb"

git add: "."
git commit: %Q{ -m "Add rspec and capybara" }

######### Guard

gem_group :development, :test do
  gem "guard-rspec"
  gem "guard-bundler"
end

run "bundle install"
run "bundle exec guard init bundler rspec"
run "sed -i '' 's/bundle exec rspec/bin\\/rspec/' Guardfile"

git add: "."
git commit: %Q{ -m "Add guard" }

######### Pages controller

run "cp -r #{File.expand_path('../code/pages_controller/spec/*', __FILE__)} spec/"
run "cp -r #{File.expand_path('../code/pages_controller/app/*', __FILE__)} app/"
run "sed -i '' \"s/# root 'welcome/root 'pages/\" config/routes.rb"

git add: "."
git commit: %Q{ -m "Add pages controller" }

######### Bootstrap

gem "bootstrap-sass"
gem "autoprefixer-rails"

run "bundle install"

run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss"
run 'echo "@import \"bootstrap-sprockets\";" >> app/assets/stylesheets/application.css.scss'
run 'echo "@import \"bootstrap\";" >> app/assets/stylesheets/application.css.scss'
run 'sed -i \'\' \'s/.*require jquery$/&\
\/\/= require bootstrap-sprockets/\' app/assets/javascripts/application.js'
run "cp #{File.expand_path('../bootstrap_templates/default.html.erb', __FILE__)} app/views/layouts/application.html.erb"

git add: "."
git commit: %Q{ -m "Add bootstrap" }
