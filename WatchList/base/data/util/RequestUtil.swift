import Foundation

extension URLRequest {
    mutating func applyBearerToken(token: String) {
        setValue(
            "\(Constants.bearerTokenKey) \(token)",
            forHTTPHeaderField: Constants.headerAuthorizationKey
        )
    }

    func log() {
        debugPrint("\(httpMethod ?? "GET") \(url?.absoluteString ?? "")")
    }

    func execute<T>(_: T.Type, session: URLSession) async throws -> T
    where T: Decodable {
        do {
            let (data, response) = try await session.data(for: self)
            log()

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.httpError(
                    statusCode: httpResponse.statusCode
                )
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try! decoder.decode(
                T.self,
                from: data
            )
            return result

        } catch let urlError as URLError {
            throw NetworkError.networkError(urlError)
        }
    }
}
