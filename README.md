# Manufacturing Batch Reporting App

This is an app I wrote for a food manufacturer, which is no longer in use.  I release it as open source as an example of my work and also in case any small manufacturers would like to use it to track their company.  Modules included:

* Batch coding and management, enabling complete traceability
* Recipe Management
* Batch Label PDF Generation for printing on to label sheets
* Ingredients ordering
* Tracking status of each batch through its workflow
* Tracking temperature through weather API
* Integration of batch scheduling into Google Calendar, for manager oversight

If anyone wants to use it, pleae contact me and I can walk you through the
changes you'll likely want to make in order to tailer the app to your own
company.

Copyright 2017 Tyler Gannon


## Configuring on heroku:

* Using buildpack for automatically running rake db:migrate
  * https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks

