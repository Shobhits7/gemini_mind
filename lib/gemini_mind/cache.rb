# frozen_string_literal: true

require "redis"
require "digest"

module GeminiMind
  # Cache implementation using Redis
  class Cache
    # Initialize the cache
    # @param config [GeminiMind::Config] The configuration
    def initialize(config)
      @config = config
      @enabled = config.cache_enabled?
      @ttl = config.cache_ttl
      
      if @enabled
        begin
          @redis = Redis.new(url: config.redis_url)
          @redis.ping # Test the connection
        rescue Redis::BaseConnectionError => e
          @enabled = false
          warn "GeminiMind: Redis cache connection failed: #{e.message}. Caching disabled."
        end
      end
    end

    # Get a value from the cache
    # @param key [String] The cache key
    # @return [String, nil] The cached value or nil if not found
    def get(key)
      return nil unless @enabled
      
      begin
        @redis.get(cache_key(key))
      rescue Redis::BaseError => e
        warn "GeminiMind: Redis cache get error: #{e.message}"
        nil
      end
    end

    # Set a value in the cache
    # @param key [String] The cache key
    # @param value [String] The value to cache
    # @return [Boolean] True if successful
    def set(key, value)
      return false unless @enabled
      
      begin
        @redis.setex(cache_key(key), @ttl, value)
        true
      rescue Redis::BaseError => e
        warn "GeminiMind: Redis cache set error: #{e.message}"
        false
      end
    end

    # Clear a specific value from the cache
    # @param key [String] The cache key
    # @return [Boolean] True if successful
    def clear(key)
      return false unless @enabled
      
      begin
        @redis.del(cache_key(key))
        true
      rescue Redis::BaseError => e
        warn "GeminiMind: Redis cache clear error: #{e.message}"
        false
      end
    end

    # Clear all cached values
    # @return [Boolean] True if successful
    def clear_all
      return false unless @enabled
      
      begin
        keys = @redis.keys("#{cache_prefix}:*")
        @redis.del(*keys) unless keys.empty?
        true
      rescue Redis::BaseError => e
        warn "GeminiMind: Redis cache clear_all error: #{e.message}"
        false
      end
    end

    private

    # Generate the full cache key with prefix
    # @param key [String] The base key
    # @return [String] The full key with prefix
    def cache_key(key)
      "#{cache_prefix}:#{key}"
    end

    # Get the cache prefix
    # @return [String] The cache prefix
    def cache_prefix
      "gemini_mind"
    end
  end
end
