# frozen_string_literal: true

module GeminiMind
  # Base error class for all GeminiMind errors
  class Error < StandardError; end
  
  # Configuration errors
  class ConfigurationError < Error; end
  
  # Connection errors
  class ConnectionError < Error; end
  class TimeoutError < ConnectionError; end
  
  # API errors
  class ApiError < Error; end
  class ResponseError < ApiError; end
  class RateLimitError < ApiError; end
  class ServiceError < ApiError; end
  class NotFoundError < ApiError; end
  
  # Cache errors
  class CacheError < Error; end
end
