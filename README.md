A place for me to keep any rails templates I come up with. Feel free to fork
of course but it's unlikely I'll accept any pull requests for other templates
as this is really for my own personal use. Knock yourself out in your own repos
though!

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

Running
=======

Clone the repository somewhere and run:

`rails new <app_name> --template=path/to/checkout/<template_name>.rb`

Templates
=========

This currently contains only one template. (And maybe only ever will)

default.rb
----------

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

