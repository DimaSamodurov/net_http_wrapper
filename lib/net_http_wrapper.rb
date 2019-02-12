require 'net_http_wrapper/version'
require 'net/http'

# Allows registering callbacks on `Net::HTTP#request` method.
module NetHttpWrapper
  class Error < StandardError
  end

  # Defines methods to be available on NetHttpWrapper class.
  module DSL
    def enable
      Net::HTTP.prepend NetHttpWrapper
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def enabled?
      @enabled
    end

    # Registers a callback that will be called upon request completion.
    #
    # Callback will receive following parameters:
    # - http:  HTTP instance,
    # - request: HTTP Request,
    # - response: HTTP Response,
    # - start_time: Request Start Time
    #
    # Example:
    #   NetHttpWrapper.after_request do |http:, request:, response:, start_time:|
    #     # e.g. log request duration
    #   end
    def after_request(&block)
      after_request_callbacks << block
    end

    # List of registered callbacks to be executed upon the request completion.
    def after_request_callbacks
      @after_request_callbacks ||= []
    end
  end

  extend DSL

  def request(req, body = nil, &block)
    start_time = Time.now
    super.tap do |resp|
      next unless NetHttpWrapper.enabled?

      NetHttpWrapper.after_request_callbacks.each do |callback|
        callback.call(http: self,
                      request: req,
                      response: resp,
                      start_time: start_time)
      end
    end
  end
end
