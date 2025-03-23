# frozen_string_literal: true

require "faraday"
require "json"

module GeminiMind
  # Client for interacting with the Gemini API
  class Client
    attr_reader :config

    # Initialize a new client
    # @param options [Hash] Options to override the default configuration
    def initialize(options = {})
      @config = GeminiMind.config.dup
      options.each do |key, value|
        @config.send("#{key}=", value) if @config.respond_to?("#{key}=")
      end
      
      @config.validate!
      @cache = Cache.new(@config) if @config.cache_enabled?
    end

    # Generate content using Gemini API
    # @param text [String] The text prompt to send to Gemini
    # @param options [Hash] Additional options
    # @return [GeminiMind::Response] The response from Gemini
    def generate_content(text, options = {})
      model = options.delete(:model) || @config.default_model
      system_instruction = options.delete(:system_instruction)
      
      # Try to retrieve from cache first if caching is enabled
      cache_key = generate_cache_key(text, model, system_instruction, options)
      if @config.cache_enabled? && (cached = @cache.get(cache_key))
        return Response.new(JSON.parse(cached))
      end
      
      # Prepare the request body
      body = prepare_request_body(text, system_instruction, options)
      
      # Make the API request
      begin
        response = connection.post(endpoint_url(model)) do |req|
          req.body = JSON.generate(body)
        end
        
        response_data = JSON.parse(response.body)
        
        # Cache the response if caching is enabled
        @cache.set(cache_key, response.body) if @config.cache_enabled?
        
        Response.new(response_data)
      rescue Faraday::Error => e
        handle_request_error(e)
      rescue JSON::ParserError => e
        raise ResponseError, "Failed to parse API response: #{e.message}"
      end
    end

    private

    # Generate a cache key based on the request parameters
    # @return [String] A unique key for caching
    def generate_cache_key(text, model, system_instruction, options)
      components = [text, model]
      components << system_instruction if system_instruction
      components << options.sort.to_s unless options.empty?
      
      Digest::SHA256.hexdigest(components.join('|'))
    end

    # Prepare the request body for the Gemini API
    # @return [Hash] The request body
    def prepare_request_body(text, system_instruction, options)
      body = {
        contents: [
          {
            parts: [
              {
                text: text
              }
            ]
          }
        ]
      }
      
      # Add system instruction if provided
      if system_instruction
        body[:system_instruction] = {
          parts: [
            {
              text: system_instruction
            }
          ]
        }
      end
      
      # Add any additional options to the request
      options.each do |key, value|
        body[key] = value
      end
      
      body
    end

    # Create a Faraday connection
    # @return [Faraday::Connection] The configured connection
    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = "https://generativelanguage.googleapis.com/#{@config.api_version}"
        conn.request :json
        conn.options.timeout = @config.timeout
        conn.adapter Faraday.default_adapter
      end
    end

    # Build the endpoint URL
    # @param model [String] The model to use
    # @return [String] The full endpoint URL
    def endpoint_url(model)
      "/models/#{model}:generateContent?key=#{@config.api_key}"
    end

    # Handle errors from the HTTP request
    # @param error [Faraday::Error] The original error
    # @raise [GeminiMind::Error] A more specific error
    def handle_request_error(error)
      case error
      when Faraday::TimeoutError
        raise TimeoutError, "Request timed out after #{@config.timeout} seconds"
      when Faraday::ConnectionFailed
        raise ConnectionError, "Connection to Gemini API failed"
      when Faraday::ResourceNotFound
        raise NotFoundError, "Requested resource or model not found"
      when Faraday::ClientError
        if error.response && error.response[:status] == 429
          raise RateLimitError, "Rate limit exceeded"
        else
          raise ApiError, "API request failed: #{error.message}"
        end
      when Faraday::ServerError
        raise ServiceError, "Gemini API service error: #{error.message}"
      else
        raise Error, "Request failed: #{error.message}"
      end
    end
  end
end
