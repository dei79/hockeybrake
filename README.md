# HockeyBrake

An extension for the amazing airbrake gem which routes crash reports to HockeyApp

[![Build Status](https://secure.travis-ci.org/dei79/hockeybrake.png)](http://travis-ci.org/dei79/hockeybrake)
[![Gem Version](https://badge.fury.io/rb/hockeybrake.png)](http://badge.fury.io/rb/hockeybrake)

## Installation 

Add this to your Gemfile
```ruby
gem 'airbrake'
gem 'hockeybrake'
```

Execute the following command for your Rails app
```shell
rails g hockeybrake
```

## Configuration

### General

Update hockeybrake.rb in config/initializers, at least the following settings needs to be changed

```ruby
  # the bundle id
  config.app_bundle_id= "###YOUR BUNDLE IDENTIFIER FROM HOCKEYAPP###"

  # The application ID in hockey app
  config.app_id="###YOUR APP SECRET###"
```

### Resque Failures

Resque comes with out of the box support for Airbrake. This gem is compatible with this support and it is well configured by default when the resque gem becomes part of your app. This behavious can be changed through configuration if needed. Just add the following to your configuration:

```ruby
  # Support for resque exception handling is enabled by default. Wit this
  # settings the resque support will be disabled. If no resque gem is installed
  # it will be disabled automatically
  config.no_resque_handler = true
``` 

## Authors

* [![endorse](https://api.coderwall.com/dei79/endorsecount.png)](https://coderwall.com/dei79)

## Contributing
 
* Fork the project
* Fix the issue
* Add specs
* Create pull request on github

## More Information

* Check out the HockeyApp documentation for custom crash reports: http://support.hockeyapp.net/kb/api/api-post-custom-crashes
