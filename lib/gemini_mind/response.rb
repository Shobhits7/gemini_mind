# frozen_string_literal: true

module GeminiMind
  # Wrapper for Gemini API responses
  class Response
    attr_reader :raw_response

    # Initialize a new response
    # @param response_data [Hash] The raw response data from the API
    def initialize(response_data)
      @raw_response = response_data
      
      # Check if the response contains error information
      if error_present?
        raise ApiError, error_message
      end
    end

    # Get the text content from the response
    # @return [String] The generated text
    def text
      return nil unless successful?
      
      # Extract text from the candidates
      candidates = @raw_response["candidates"] || []
      return nil if candidates.empty?
      
      # Get the content from the first candidate
      first_candidate = candidates.first
      return nil unless first_candidate && first_candidate["content"]
      
      # Extract all text parts and join them
      parts = first_candidate["content"]["parts"] || []
      parts.map { |part| part["text"] }.join(" ")
    end

    # Check if the response was successful
    # @return [Boolean] True if the response contains valid content
    def successful?
      !@raw_response.nil? && 
      @raw_response.key?("candidates") && 
      !@raw_response["candidates"].empty?
    end

    # Get the safety ratings from the response
    # @return [Array] The safety ratings
    def safety_ratings
      return [] unless successful?
      
      @raw_response["candidates"].first["safetyRatings"] || []
    end

    # Check if the content was blocked due to safety concerns
    # @return [Boolean] True if the content was blocked
    def content_blocked?
      return false unless successful?
      
      candidates = @raw_response["candidates"] || []
      return false if candidates.empty?
      
      candidates.first["finishReason"] == "SAFETY"
    end

    # Get the usage metrics from the response
    # @return [Hash] The usage metrics
    def usage_metrics
      @raw_response["usageMetadata"] || {}
    end

    private

    # Check if the response contains error information
    # @return [Boolean] True if an error is present
    def error_present?
      @raw_response && @raw_response.key?("error")
    end

    # Get the error message from the response
    # @return [String] The error message
    def error_message
      return "Unknown error" unless error_present?
      
      error = @raw_response["error"]
      "#{error['message']} (code: #{error['code']})"
    end
  end
end
