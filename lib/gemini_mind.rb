# frozen_string_literal: true

require_relative "gemini_mind/version"
require_relative "gemini_mind/client"
require_relative "gemini_mind/config"
require_relative "gemini_mind/error"
require_relative "gemini_mind/response"
require_relative "gemini_mind/cache"

# Main module for the GeminiMind gem
module GeminiMind
  class << self
    # Access the configuration object
    # @return [GeminiMind::Config]
    def config
      @config ||= Config.new
    end

    # Configure the GeminiMind gem
    # @yield [config] Configuration object
    # @example
    #   GeminiMind.configure do |config|
    #     config.api_key = "YOUR_API_KEY"
    #     config.default_model = "gemini-2.0-pro"
    #     config.cache_enabled = true
    #   end
    def configure
      yield(config) if block_given?
      config
    end

    # Create a new client instance
    # @param options [Hash] Options to override the default configuration
    # @return [GeminiMind::Client] A new client instance
    def client(options = {})
      Client.new(options)
    end

    # Generate content using the default client
    # @param text [String] The text prompt to send to Gemini
    # @param options [Hash] Additional options
    # @return [GeminiMind::Response] The response from Gemini
    def generate_content(text, options = {})
      client.generate_content(text, options)
    end
  end
end