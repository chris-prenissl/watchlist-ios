import Foundation
import XCTest

@testable import WatchList

final class TMDBClientTests: XCTestCase {
    private var client: TMDBClient!
    private var urlSession: URLSession!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        client = TMDBClient(apiKey: "dummy_api_key", urlSession: urlSession)
    }

    override func tearDown() {
        client = nil
        MockURLProtocol.mockResponse = nil
        super.tearDown()
    }

    func testSearchMovie_success_returnsMovies() async throws {
        let expectedMovies = [
            MovieSearchItemDto(
                id: 1,
                title: "Batman",
                overview: "Batman overview"
            ),
            MovieSearchItemDto(
                id: 2,
                title: "Superman",
                overview: "Superman overview"
            ),
        ]
        let dto = MovieSearchResultDto(results: expectedMovies)
        let data = try JSONEncoder().encode(dto)
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

        let result = try await client.searchMovie(query: "hero")

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].title, "Batman")
        XCTAssertEqual(result[0].overview, "Batman overview")
        XCTAssertEqual(result[1].title, "Superman")
        XCTAssertEqual(result[1].overview, "Superman overview")
    }

    func testSearchMovie_404_throws() async throws {
        MockURLProtocol.mockResponse = (
            data: Data(),
            urlResponse: HTTPURLResponse(
                url: URL(string: "URL")!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!,
            shouldThrowUrlError: false
        )
        
        do {
            _ = try await client.searchMovie(query: "hero")
            XCTFail()
        } catch {
            XCTAssertNotNil(error as? NetworkError)
            if case NetworkError.httpError(let code) = error {
                XCTAssertEqual(code, 404)
            } else {
                XCTFail("Expected networkError but got \(error)")
            }
        }
    }
}
