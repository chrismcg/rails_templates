This currently contains only one template.

.railsrc
========

You'll need to set the default database etc. in your `~/.railsrc`. Mine looks
like:

```
-d postgresql
--skip-test-unit
--skip-bundle
```

I prefer starting with PostgreSQL, the template installs RSpec so test-unit
isn't needed, and bundler is run when we need it to.

default.rb
==========

Inspired (and mostly taken from) [Starting a new Rails
project](https://woss.name/articles/starting-a-new-rails-project/). Thanks
[@mathie](https://github.com/mathie)!

* RSpec
* Capybara
* Guard
* PagesController mapped to home
* DotEnv
* Pry
* Puma
* Bootstrap with skeleton application.html.erb

