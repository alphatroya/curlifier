# curlifier

A lightweight Swift framework that converts `URLRequest` objects into executable curl command strings. Perfect for debugging network requests, creating documentation, and reproducing API calls outside your application.

## Features

- **Simple API**: Convert any `URLRequest` to a curl command with a single function call
- **Comprehensive HTTP support**: Works with all HTTP methods (GET, POST, PUT, PATCH, DELETE, etc.)
- **Header preservation**: Automatically includes HTTP headers in the generated curl command
- **Request body handling**: Supports POST/PUT data by including request body content
- **Security-conscious**: Intentionally excludes Cookie headers to prevent accidental token exposure
- **Shell-safe**: Properly quotes all parameters to prevent command injection
- **Zero dependencies**: Pure Swift implementation using only Foundation

## Installation

### Swift Package Manager

Add curlifier to your project using Xcode or by adding it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/alphatroya/curlifier.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["curlifier"]
)
```

## Usage

### Basic Example

```swift
import curlifier
import Foundation

// Create a URLRequest
var request = URLRequest(url: URL(string: "https://api.example.com/users")!)
request.httpMethod = "GET"
request.setValue("application/json", forHTTPHeaderField: "Accept")

// Convert to curl command
do {
    let curlCommand = try curl(from: request)
    print(curlCommand)
    // Output: curl -v -X GET -H 'Accept: application/json' 'https://api.example.com/users'
} catch {
    print("Error: \(error)")
}
```

### POST Request with JSON Body

```swift
import curlifier
import Foundation

var request = URLRequest(url: URL(string: "https://api.example.com/users")!)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = """
{
    "name": "John Doe",
    "email": "john@example.com"
}
""".data(using: .utf8)

let curlCommand = try curl(from: request)
print(curlCommand)
// Output: curl -v -X POST -H 'Content-Type: application/json' -d '{"name": "John Doe", "email": "john@example.com"}' 'https://api.example.com/users'
```

### Error Handling

```swift
import curlifier
import Foundation

let invalidRequest = URLRequest(url: URL(string: "")!) // Invalid URL

do {
    let curlCommand = try curl(from: invalidRequest)
} catch let error as WrongRequestError {
    print("Invalid request: \(error.localizedDescription)")
} catch {
    print("Unexpected error: \(error)")
}
```

## API Reference

### Functions

#### `curl(from:)`
```swift
func curl(from request: URLRequest) throws -> String
```

Converts a `URLRequest` object into an equivalent curl command string.

**Parameters:**
- `request`: The `URLRequest` object to convert

**Returns:** A `String` containing the curl command

**Throws:** `WrongRequestError` if the request is invalid (missing URL or HTTP method)

### Error Types

#### `WrongRequestError`
```swift
struct WrongRequestError: Error {
    var localizedDescription: String
}
```

An error type thrown when the provided `URLRequest` cannot be converted to a curl command.

## Requirements

- Swift 5.7+
- Foundation framework
- Compatible with macOS, iOS, watchOS, tvOS, and Linux

## Use Cases

- **Debug network requests**: Convert your app's URLRequest objects to curl commands for testing
- **API documentation**: Generate curl examples for your API documentation
- **Reproduce issues**: Create curl commands to reproduce network-related bugs
- **Testing**: Verify request formation in unit tests
- **Development tools**: Build debugging utilities around network requests

## Security Notes

- **Cookie headers are intentionally excluded** from the generated curl commands to prevent accidental exposure of authentication tokens
- All parameters are properly shell-quoted to prevent command injection
- The `-v` (verbose) flag is always included for detailed debugging output

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.
