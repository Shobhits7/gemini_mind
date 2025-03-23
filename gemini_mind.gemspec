# frozen_string_literal: true

require_relative "lib/gemini_mind/version"

Gem::Specification.new do |spec|
  spec.name = "gemini_mind"
  spec.version = GeminiMind::VERSION
  spec.authors = ["Shobhit Jain"]
  spec.email = ["shobjain09@gmail.com"]

  spec.summary = "Ruby gem for generating content using Google's Gemini API"
  spec.description = "GeminiMind provides a simple, robust interface to interact with Google's Gemini generative AI models"
  spec.homepage = "https://github.com/shobhits7/gemini_mind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shobhits7/gemini_mind"
  spec.metadata["changelog_uri"] = "https://github.com/shobhits7/gemini_mind/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
    (File.expand_path(f) == __FILE__) || 
    f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor]) || 
    f.end_with?(".gem")
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-retry", "~> 2.0"
  spec.add_dependency "redis", "~> 5.0", ">= 5.0.0"

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "vcr", "~> 6.1"
  spec.add_development_dependency "rubocop", "~> 1.50"
end