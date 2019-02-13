# NetHttpWrapper
[![Build Status](https://travis-ci.org/DimaSamodurov/net_http_wrapper.svg?branch=master)](https://travis-ci.org/DimaSamodurov/net_http_wrapper)
[![Code Climate](https://api.codeclimate.com/v1/badges/83512d69c7a20acd6582/maintainability)](https://codeclimate.com/github/DimaSamodurov/net_http_wrapper/maintainability)

NetHttpWrapper adds callbacks to Net::HTTP requests.

It can be used e.g. for logging purposes, 
but the library does not make any assumptions on how to do this.
It does not add neither additional dependency nor convention to your project.

You can use Rails logger, external service or just print to STDOUT, 
using format you need. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'net_http_wrapper'
```

## Usage

Register the `after_request` callback as follows:

```ruby
NetHttpWrapper.after_request do |http:, request:, response:, start_time:|
  # log request/duration, store metrics, analyze response body etc.
end 
```
You can add multiple callbacks. 
Callbacks will be called in the same order as registered.

Note: you are responsible for error handling within the block! 

Enable the callbacks invocation (initially disabled):
```ruby
NetHttpWrapper.enable
```

### Example

Snippet below can be added as an initializer to Rails application.

```ruby
NetHttpWrapper.enable

NetHttpWrapper.after_request do |http:, request:, response:, start_time:|
  request_duration = (Time.now - start_time).round(3)
  request_url =
    "http#{"s" if http.use_ssl?}://#{http.address}:#{http.port}#{request.path}"

  Rails.logger.info(name: 'http_request',
                    method: request.method,
                    url: request_url,
                    status: response.code,
                    duration: request_duration)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. 
Then, run `rake` to run the code style check and the tests.
You can also run `bundle exec bin/console` for an interactive prompt that will allow you to experiment.

You can also see example in action running 
`bundle exec ruby examples/log_to_stdout.rb`


To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, 
and then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub 
at https://github.com/dimasamodurov/net_http_wrapper.
