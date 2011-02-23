Jasmine Sauce
=============

The jasmine-sauce gem provides the glue necessary to run your Jasmine tests
across browsers in the Sauce OnDemand cloud.



Getting Started
---------------

1. Add jasmine-sauce to your Gemfile
2. bundle install
3. bundle exec sauce config <YOUR_SAUCE_USENRAME> <YOUR_SAUCE_PASSWORD>
4. rails generate sauce:jasmine
5. rake jasmine:ci:sauce
