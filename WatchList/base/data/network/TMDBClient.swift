import Foundation

struct TMDBSchema {
    static let tmdbBaseUrl = "https://api.themoviedb.org/3"
    static let searchMoviePath = "search/movie"
    static let moviePosterPath = "https://image.tmdb.org/t/p/w1280"
}

struct TMDBSearchParameters {
    static let query = "query"
    static let includeAdult = "include_adult"
}

class TMDBClient: TMDBClientProtocol {
    private let apiKey: String
    private let baseUrl = URL(string: TMDBSchema.tmdbBaseUrl)!
    private let urlSession: URLSession

    init(apiKey: String? = nil, urlSession: URLSession = .shared) {
        if let apiKey = apiKey {
            self.apiKey = apiKey
        } else {
            self.apiKey = try! Bundle.main
                .loadProperty(
                    bundleKey: Constants.secretsBundleKey,
                    propertyKey: Constants.tmdbApiKeyKey,
                    propertyType: String.self
                )
        }
        self.urlSession = urlSession
    }

    func searchMovie(query: String) async throws -> [MovieSearchItemDto] {
        var request = URLRequest(
            url:
                baseUrl
                .appendingPathComponent(TMDBSchema.searchMoviePath)
                .appending(
                    queryItems: [
                        .init(name: TMDBSearchParameters.query, value: query),
                        .init(
                            name: TMDBSearchParameters.includeAdult,
                            value: false.description
                        ),
                    ]
                )
        )
        request.applyBearerToken(token: apiKey)

        let movieSearchResult = try await request.execute(
            MovieSearchResultDto.self,
            session: urlSession
        )
        return movieSearchResult.results
    }
}
