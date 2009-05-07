# RAILS IS SO LAST YEAR

## ..or, "How to get Rails 3, today."

### by Alex Chaffee, @alexch, alex@cohuman.com, http://github.com/alexch

DHH said he made Rails because he felt the frameworks were getting in the way between him and the app

I feel the same way about Rails.

## What's in a webapp framework?

* router/dispatcher
* controller code
* domain objects
* views
* utilities
  * caching
  * helpers
* ORM

## What is Rails?

* routes.rb
  * confusing
  * separated from controller
* controllers: 
  * not bad
* models (not domain objects)
* views
  * ERB is ugly; HAML is underpowered
* utilities
  * caching
  * helpers
*  ActiveRecord
  * migrations rock
* scaffolding
  * deprecated
*  plugins
  * gems are better
* automatic class loading & reloading
  * loadpath munging
  * confusing; not "standard Ruby"
  * hard to debug
* miscellaneous utilities
  * active_support helpers
  * caching

## What is Vegas?

* Sinatra
  * clear routing DSL
  * directly connected 
* Erector
  * OO view framework
* ActiveRecord
  * if I have to use a RDBMS, I want migrations
* no scaffolds
  * but wouldn't it be nice if we had activescaffold type components for Erector?
* gems
  * why isn't every Rails plugin a gem?
* Standard ruby loading and reloading
  * req
  * run.rb (rake run)
* Rack::Cache
* Mix in ActiveSupport or ActionView with 'include'

## Everything else is just code.

This app is a demonstration template with some rake tasks and user
authentication, using Sinatra, Erector, ActiveRecord, and "req".

Auto-loading is handled by "run.rb" (aka "rake run") which launches the app,
then scans the file system for changes. When there's a file change, it kills
the running app and relaunches. This takes <2 sec.

Classes must declare their dependencies (if they're out of alphabetical order),
or declare global primary dependencies in setup.rb.

But Yehuda says that Rails will always provide things you didn't think of yet,
and that this sort of architecture will be not only possible and supported but
very easy in Rails 3.

So maybe this is a silly experiment. But Rails 3 isn't here yet! So if you want
to do this kind of app today, clone Vegas and go for it.

Also, if more people see how clean and non-magic this is, then maybe we'll be
able to demand that Rails 3 is just as clean.

## [http://github.com/alexch/vegas](http://github.com/alexch/vegas)