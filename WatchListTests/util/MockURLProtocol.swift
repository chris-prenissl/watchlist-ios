import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponse: (Data, HTTPURLResponse)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let (data, response) = MockURLProtocol.mockResponse {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            let error = NSError(domain: "MockURLProtocolError", code: -1, userInfo: nil)
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
