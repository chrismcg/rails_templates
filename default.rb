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

create_file ".ruby-version" do
  "#{RUBY_VERSION}\n"
end
inject_into_file "Gemfile", after: /^source.*\n/ do
 %(ruby File.read(File.expand_path("../.ruby-version", __FILE__)).chomp)
end

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
copy_file File.expand_path('../webserver_config/puma.rb', __FILE__), "config/puma.rb"

# Configure dev for just one worker
create_file ".env" do
  "PUMA_WORKERS=1\n"
end

# Configure foreman
create_file "Procfile" do
  "web: bundle exec puma --config config/puma.rb\n"
end

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
gsub_file "spec/spec_helper.rb", /^=(begin|end)$/, ""

git add: "."
git commit: %Q{ -m "Add rspec and capybara" }

######### Guard

gem_group :development, :test do
  gem "guard-rspec"
  gem "guard-bundler"
end

run "bundle install"
run "bundle exec guard init bundler rspec"
gsub_file "Guardfile", "bundle exec rspec", "bin/rspec"

git add: "."
git commit: %Q{ -m "Add guard" }

######### Pages controller

run "cp -r #{File.expand_path('../code/pages_controller/spec/*', __FILE__)} spec/"
run "cp -r #{File.expand_path('../code/pages_controller/app/*', __FILE__)} app/"
gsub_file "config/routes.rb", "# root 'welcome", "root 'pages"

git add: "."
git commit: %Q{ -m "Add pages controller" }

######### Bootstrap

gem "bootstrap-sass"
gem "autoprefixer-rails"

run "bundle install"

FileUtils.mv "app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.scss"
inject_into_file "app/assets/stylesheets/application.css.scss", after: " */\n" do <<-CSS
@import "bootstrap-sprockets";
@import "bootstrap";
CSS
end
insert_into_file "app/assets/javascripts/application.js", after: /.*require jquery\n/ do
  "//= require bootstrap-sprockets\n"
end
# Use cp rather than copy_file here otherwise we get asked if we really want to
run "cp -r #{File.expand_path('../bootstrap_templates/*', __FILE__)} ."

git add: "."
git commit: %Q{ -m "Add bootstrap" }
