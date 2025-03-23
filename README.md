# GeminiMind

GeminiMind is a Ruby gem that provides a simple and powerful interface to Google's Gemini AI models. It allows you to easily generate content using Gemini's API with features like caching, error handling, and configuration management.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gemini_mind'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install gemini_mind
```

## Usage

### Basic Usage

```ruby
require 'gemini_mind'

# Configure the gem with your API key
GeminiMind.configure do |config|
  config.api_key = "YOUR_GEMINI_API_KEY"
end

# Generate content
response = GeminiMind.generate_content("Tell me a story about a robot learning to paint")
puts response.text
```

### Advanced Configuration

```ruby
GeminiMind.configure do |config|
  config.api_key = "YOUR_GEMINI_API_KEY"
  config.default_model = "gemini-2.0-pro"  # Use a different model
  config.timeout = 60                      # Set timeout to 60 seconds
  config.max_retries = 2                   # Retry failed requests 2 times
  
  # Enable caching
  config.cache_enabled = true
  config.cache_ttl = 1800                  # Cache for 30 minutes
  config.redis_url = "redis://redis:6379/1"  # Custom Redis URL
end
```

### Using System Instructions

```ruby
# Create a client with custom options
client = GeminiMind.client

# Generate content with a system instruction
response = client.generate_content(
  "What's your name?",
  system_instruction: "You are a professional chef named Chef Gordon."
)

puts response.text
```

### Working with Responses

```ruby
response = GeminiMind.generate_content("Explain quantum computing")

# Check if the response was successful
if response.successful?
  puts response.text
  
  # Access safety ratings
  response.safety_ratings.each do |rating|
    puts "Category: #{rating['category']}, Score: #{rating['score']}"
  end
  
  # Check usage metrics
  puts "Prompt tokens: #{response.usage_metrics['promptTokenCount']}"
  puts "Candidates tokens: #{response.usage_metrics['candidatesTokenCount']}"
end
```

### Error Handling

```ruby
begin
  response = GeminiMind.generate_content("Tell me a story")
  puts response.text
rescue GeminiMind::ApiError => e
  puts "API Error: #{e.message}"
rescue GeminiMind::ConnectionError => e
  puts "Connection Error: #{e.message}"
rescue GeminiMind::Error => e
  puts "General Error: #{e.message}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shobhits7/gemini_mind.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).