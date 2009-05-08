# RAILS IS SO LAST YEAR

## ..or, "How to get Rails 3, today."

### by Alex Chaffee, @alexch, alex@cohuman.com, http://github.com/alexch

At the RailsConf keynote, DHH said he made Rails because he felt the frameworks
were getting in the way between him and the app.

I feel the same way about Rails.

Vegas is my admittedly lame attempt at demonstrating an "un-framework" -- a
Ruby webapp using Rack, Sinatra, Erector, ActiveRecord, and minimal glue.
It's a straw man, to be used as one side of a debate about what's the proper
scope for a Ruby framework. Or, more dramatically... 

What's Rails *for*, again?

## What's in a webapp framework?

* router/dispatcher
* controller code
* domain objects
* views
* utilities
  * caching
  * helpers
* ORM
* (what else?)

## What is Rails?
### (and why I don't like it)
* routes.rb
  * confusing
  * separated from controller
* controllers: 
  * not bad
  * leaky encapsulation - all instance variables in controller are shared with view
  * helpers - not so good; promotes "bleeding abstraction" with "helpers :all" between controllers and views
* models
  * models are good, but there's no spot in the directory structure for non-persistent domain objects (e.g. presenters), so logic tends to leak into controllers
* views
  * ERB is ugly; partials are slow; content_for is magic
  * HAML is beautiful but underpowered
  * Erector rocks but it's very hard to squeeze it into the Rails codebase
* utilities
  * caching - good
  * active_support - useful
*  ActiveRecord
  * migrations rock
  * ActiveRecord is very usable
* scaffolding
  * deprecated
  * activescaffold is a fine idea for admin or quick-and-dirty sites
*  plugins
  * gems are better
* automatic class loading & reloading
  * loadpath munging
  * confusing; not "standard Ruby"
  * hard to debug
* If anyone thinks of anything Rails "is" that I haven't listed here, please tell me

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
  * run.rb (rake run) - reloads entire app when filesystem changes
    * could also use "shotgun" if I could nip off static file requests
* Rack::Cache
* Mix in ActiveSupport or ActionView helpers with 'include'

## Everything else is just code.

This app is a demonstration template with some rake tasks and user
authentication, using Sinatra, Erector, ActiveRecord, and "req". Feel free to 
clone or fork it and play around to see if and how it would fit your needs for
an unframework.

Auto-loading is handled by "run.rb" (aka "rake run") which launches the app,
then scans the file system for changes. When there's a file change, it kills
the running app and relaunches. This takes <2 sec.

Classes must declare their dependencies (if they're out of alphabetical order),
or declare global primary dependencies in setup.rb. The "req" method allows you to
specify requires relative to the project root, not the current directory, so ".." 
is out of require paths, and "move file" refactoring is easier.

But Yehuda says that Rails will always provide things you didn't think of yet,
and that this sort of architecture will be not only possible and supported but
very easy in Rails 3. So maybe this is a silly experiment. 

But Rails 3 isn't here yet! So if you want to do this kind of app today, clone
Vegas and go for it.

Also, if more people see how clean and non-magic this is, then maybe we'll be
able to demand that Rails 3 is just as clean.

## [http://github.com/alexch/vegas](http://github.com/alexch/vegas)
