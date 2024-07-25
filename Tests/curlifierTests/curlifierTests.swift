import curlifier
import Foundation
import Testing

struct CurlifierTests {
    @Test func wrongRequest() throws {
        var request = URLRequest(url: URL(string: "hh")!)
        request.url = nil
        #expect(throws: (any Error).self) {
            try curl(from: request)
        }
    }

    @Test func wrongRequestError() throws {
        var request = URLRequest(url: URL(string: "hh")!)
        request.url = nil
        do {
            _ = try curl(from: request)
            Issue.record("curl command should fail in that case")
        } catch {
            guard let err = error as? WrongRequestError else {
                Issue.record("wrong error type was reported")
                return
            }
            #expect(err.localizedDescription == "cURL command can't be generated")
        }
    }

    @Test func getRequest() throws {
        let request = URLRequest(url: URL(string: "https://curl.se")!)
        let desc = try curl(from: request)
        #expect(desc == "curl -v -X GET 'https://curl.se'")
    }

    @Test func postRequest() throws {
        var request = URLRequest(url: URL(string: "https://curl.se")!)
        request.httpMethod = "POST"
        request.httpBody = "{ \"data\": 1 }".data(using: .utf8)
        let desc = try curl(from: request)
        #expect(desc == "curl -v -X POST -d '{ \"data\": 1 }' 'https://curl.se'")
    }

    func getWithHeadersRequest() throws {
        var request = URLRequest(url: URL(string: "https://curl.se")!)
        request.allHTTPHeaderFields = ["Hello": "Curl"]
        let desc = try curl(from: request)
        #expect(desc == "curl -v -X GET -H 'Hello: Curl' 'https://curl.se'")
    }
}
