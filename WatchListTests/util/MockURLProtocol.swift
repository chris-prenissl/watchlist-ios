import Foundation

@testable import WatchList

class MockURLProtocol: URLProtocol {
    static var mockResponse:
        (data: Data, urlResponse: URLResponse, shouldThrowUrlError: Bool)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    { request }

    override func startLoading() {
        if let (data, response, shouldThrowUrlError) = MockURLProtocol
            .mockResponse
        {
            if !shouldThrowUrlError {
                self.client?.urlProtocol(
                    self,
                    didReceive: response,
                    cacheStoragePolicy: .notAllowed
                )
                self.client?.urlProtocol(self, didLoad: data)
            } else {
                self.client?
                    .urlProtocol(
                        self,
                        didFailWithError: URLError(.badServerResponse)
                    )
            }
        } else {
            let error = NSError(
                domain: "MockURLProtocolError",
                code: -1,
                userInfo: nil
            )
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
