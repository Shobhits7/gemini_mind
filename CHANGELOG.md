# Changelog

## [0.1.4] - 2025-03-23

### Fixed
- Removed problematic Faraday retry middleware
- Improved error handling for empty responses
- Added better JSON parsing error reporting
- Enhanced error response handling with more descriptive messages

## [0.1.3] - 2025-03-23

### Fixed
- Attempted to fix Faraday retry middleware configuration

## [0.1.2] - 2025-03-23

### Fixed
- Fixed Faraday retry middleware configuration to use correct parameter names
- Updated client connection setup with proper retry options

## [0.1.0] - 2025-03-23

### Added
- Initial release of GeminiMind
- Support for generating content using Gemini API
- Configuration management with environment variable support
- Error handling with specific error classes
- Redis-based caching system
- Retry mechanism for failed requests