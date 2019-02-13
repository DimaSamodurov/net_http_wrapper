# NetHttpWrapper
[![Build Status](https://travis-ci.org/DimaSamodurov/net_http_wrapper.svg?branch=master)](https://travis-ci.org/DimaSamodurov/net_http_wrapper)
[![Code Climate](https://api.codeclimate.com/v1/badges/83512d69c7a20acd6582/maintainability)](https://codeclimate.com/github/DimaSamodurov/net_http_wrapper/maintainability)

Wraps Net::HTTP requests with callbacks e.g. for logging purposes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'net_http_wrapper', '~> 0.0.1', github: '<path_to_repo'
```

## Usage

Register after_request callback as follows:

```ruby
NetHttpWrapper.after_request do |http:, request:, response:, start_time:|
  # log request/duration, store metrics, analyze response body etc.
end 
```
Note: you are responsible on error handling within the block.

Then enable callbacks anytime

```ruby
NetHttpWrapper.enable
```

### Example

Snippet below can be added as an initializer to Rails application.
Besides, library does not depend on Rails.

```ruby
NetHttpWrapper.enable

NetHttpWrapper.after_request do |http:, request:, response:, start_time:|
  request_duration = (Time.current - start_time).round(3)
  request_url =
    URI.decode("http#{"s" if http.use_ssl?}://#{http.address}:#{http.port}#{request.path}")

  Rails.logger.info(name: 'http_request',
                    method: request.method,
                    url: request_url,
                    status: response.code,
                    duration: request_duration)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. 
Then, run `rake spec` to run the tests, and run `rubocop` to check code style.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, 
and then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub 
at https://github.com/[USERNAME]/net_http_wrapper.
