# Changelog

## [0.1.3] - 2025-03-23

### Fixed
- Made Faraday retry configuration robust across different versions
- Added fallback mechanisms for retry middleware configuration
- Added graceful degradation for connection setup

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