# RAILS IS SO LAST YEAR

## ..or, "How to get Rails 3, today."

DHH said he made Rails because he felt the frameworks were getting in the way between him and the app

I feel the same way about Rails.

## What is Rails?

*  routes
*  views (ERB, HAML, etc)
*  databases
  * migrations
*  scaffolding
*  plugins
*  loadpath munging
  * automatic class loading and reloading
* active_support helpers
* caching

## What is Vegas?

* Sinatra
* Erector
* ActiveRecord
* no scaffolds, 
  * don't miss em
  * wouldn't it be nice if we had activescaffold type components for Erector
*  gems
  * why isn't every plugin a gem?
* req
  * run.rb (rake run)
* Rack::Cache

## Everything else is just code.

This app is a demonstration template with some rake tasks and user
authentication, using Sinatra, Erector, ActiveRecord, and "req".

Auto-loading is handled by "run.rb" (aka "rake run") which 

Classes must declare their dependencies (if they're out of alphabetical order),
or declare global primary dependencies in setup.rb.

But Yehuda says that Rails will always provide things you didn't think of yet.
So maybe this is a silly experiment. But Rails 3 isn't here yet! So if you want
to do this kind of app today, clone Vegas and go for it.

