import Foundation
import OpenAPIRuntime
import HTTPTypes

struct BearerTokenMiddleware: ClientMiddleware {
    let bearerToken: String

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        let authorizationValue = "Bearer \(bearerToken)"
        request.headerFields[.authorization] = authorizationValue
        return try await next(request, body, baseURL)
    }
}
