# frozen_string_literal: true

module GeminiMind
  # Configuration class for GeminiMind
  class Config
    attr_accessor :api_key, :default_model, :api_version, :timeout, 
                  :max_retries, :cache_enabled, :cache_ttl, :redis_url

    def initialize
      # API settings
      @api_key = ENV["GEMINI_API_KEY"]
      @default_model = "gemini-2.0-flash"
      @api_version = "v1beta"
      
      # HTTP settings
      @timeout = 30
      @max_retries = 3
      
      # Caching settings
      @cache_enabled = false
      @cache_ttl = 3600 # 1 hour
      @redis_url = ENV["REDIS_URL"] || "redis://localhost:6379/0"
    end

    # Validate that the configuration is valid
    # @raise [GeminiMind::ConfigurationError] If configuration is invalid
    def validate!
      if api_key.nil? || api_key.empty?
        raise ConfigurationError, "API key is required. Set it via GeminiMind.configure or ENV['GEMINI_API_KEY']"
      end

      if !cache_enabled? && cache_ttl <= 0
        raise ConfigurationError, "Cache TTL must be positive when cache is enabled"
      end
    end

    # Check if caching is enabled
    # @return [Boolean] True if caching is enabled
    def cache_enabled?
      @cache_enabled
    end
  end
end
