import Foundation
import XCTest

@testable import WatchList

final class RequestUtilTest: XCTestCase {
    private var urlSession: URLSession!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
    }

    override func tearDown() {
        MockURLProtocol.mockResponse = nil
        super.tearDown()
    }

    func testExecute_success() async throws {
        let url = URL(string: "https://example.com")!
        let urlRequest = URLRequest(url: url)
        let data = try JSONEncoder().encode(1)
        MockURLProtocol.mockResponse = (
            data: data,
            urlResponse: HTTPURLResponse(
                url: URL(string: "URL")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!,
            shouldThrowUrlError: false
        )

        let result = try! await urlRequest.execute(
            Int.self,
            session: urlSession
        )

        XCTAssertEqual(result, 1)
    }

    func testExecute_urlError() async throws {
        let url = URL(string: "!%&§")!
        let urlRequest = URLRequest(url: url)
        let data = try JSONEncoder().encode(1)
        MockURLProtocol.mockResponse = (
            data: data,
            urlResponse: HTTPURLResponse(
                url: URL(string: "URL")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!,
            shouldThrowUrlError: true
        )

        do {
            let _ = try await urlRequest.execute(
                Int.self,
                session: urlSession
            )
            XCTFail()
        } catch {
            XCTAssertTrue(error is NetworkError)
            let networkError = error as! NetworkError
            if case .networkError(_) = networkError {
            } else {
                XCTFail("Expected other error")
            }
        }
    }

    func testExecute_httpResponseError() async throws {
        let url = URL(string: "!%&§")!
        let urlRequest = URLRequest(url: url)
        let data = try JSONEncoder().encode(1)
        MockURLProtocol.mockResponse = (
            data: data,
            urlResponse: URLResponse(),
            shouldThrowUrlError: false
        )

        do {
            let _ = try await urlRequest.execute(
                Int.self,
                session: urlSession
            )
            XCTFail()
        } catch {
            XCTAssertTrue(error is NetworkError)
            let networkError = error as! NetworkError
            if case .invalidResponse = networkError {
            } else {
                XCTFail("Expected other error")
            }
        }
    }
    
    func testExecute_httpResponse404() async throws {
        let url = URL(string: "!%&§")!
        let urlRequest = URLRequest(url: url)
        let data = try JSONEncoder().encode(1)
        MockURLProtocol.mockResponse = (
            data: data,
            urlResponse: HTTPURLResponse(
                url: URL(string: "URL")!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!,
            shouldThrowUrlError: false
        )

        do {
            let _ = try await urlRequest.execute(
                Int.self,
                session: urlSession
            )
            XCTFail()
        } catch {
            XCTAssertTrue(error is NetworkError)
            let networkError = error as! NetworkError
            if case .httpError(let statusCode) = networkError {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected other error")
            }
        }
    }
}
