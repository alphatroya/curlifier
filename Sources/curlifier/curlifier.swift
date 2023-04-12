import Foundation

public struct WrongRequestError: Error {
    public var localizedDescription: String {
        "cURL command can't be generated"
    }
}

public func curl(from request: URLRequest) throws -> String {
    guard let url = request.url,
          let method = request.httpMethod
    else {
        throw WrongRequestError()
    }

    var components = ["curl -v -X \(method)"]

    if let headerFields = request.allHTTPHeaderFields {
        for (field, value) in headerFields where field != "Cookie" {
            components.append("-H '\(field): \(value)'")
        }
    }

    if let httpBody = request.httpBody.flatMap({ String(data: $0, encoding: .utf8) }) {
        components.append("-d '\(httpBody)'")
    }

    components.append("'\(url.absoluteString)'")

    return components.joined(separator: " ")
}
