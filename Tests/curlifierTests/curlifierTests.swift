import curlifier
import XCTest

final class curlifierTests: XCTestCase {
    func testWrongRequest() throws {
        var request = URLRequest(url: URL(string: "hh")!)
        request.url = nil
        XCTAssertThrowsError(try curl(from: request))
    }

    func testWrongRequestError() throws {
        var request = URLRequest(url: URL(string: "hh")!)
        request.url = nil
        do {
            _ = try curl(from: request)
            XCTFail("curl command should fail in that case")
        } catch {
            guard let err = error as? WrongRequestError else {
                XCTFail("wrong error type was reported")
                return
            }
            XCTAssertEqual(err.localizedDescription, "cURL command can't be generated")
        }
    }

    func testGETRequest() throws {
        let request = URLRequest(url: URL(string: "https://curl.se")!)
        let desc = try curl(from: request)
        XCTAssertEqual(desc, "curl -v -X GET 'https://curl.se'")
    }

    func testPOSTRequest() throws {
        var request = URLRequest(url: URL(string: "https://curl.se")!)
        request.httpMethod = "POST"
        request.httpBody = "{ \"data\": 1 }".data(using: .utf8)
        let desc = try curl(from: request)
        XCTAssertEqual(desc, "curl -v -X POST -d '{ \"data\": 1 }' 'https://curl.se'")
    }

    func testGETWithHeadersRequest() throws {
        var request = URLRequest(url: URL(string: "https://curl.se")!)
        request.allHTTPHeaderFields = ["Hello": "Curl"]
        let desc = try curl(from: request)
        XCTAssertEqual(desc, "curl -v -X GET -H 'Hello: Curl' 'https://curl.se'")
    }
}
