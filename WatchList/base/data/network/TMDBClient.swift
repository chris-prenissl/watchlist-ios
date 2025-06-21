import Foundation

struct TMDBSchema {
    static let tmdbBaseUrl = "https://api.themoviedb.org/3"
    static let searchMoviePath = "search/movie"
}

class TMDBClient: TMDBClientProtocol {
    private let apiKey: String
    private let baseUrl = URL(string: TMDBSchema.tmdbBaseUrl)!

    init() {
        guard
            let secretsBundleURL = Bundle.main.url(
                forResource: Constants.secretsBundleKey,
                withExtension: Constants.plistExtension
            ),
            let secretsData = try? Data(contentsOf: secretsBundleURL),
            let secretsPropertyList =
                try? PropertyListSerialization.propertyList(
                    from: secretsData,
                    options: [],
                    format: nil
                ),
            let secretsDict = secretsPropertyList as? [String: Any],
            let apiKey = secretsDict[Constants.tmdbApiKeyKey] as? String
        else {
            fatalError("Failed to load Secrets")
        }
        self.apiKey = apiKey
    }

    func searchMovie(query: String) async -> [MovieSearchItemDto] {
        var request = URLRequest(
            url:
                baseUrl
                .appendingPathComponent(TMDBSchema.searchMoviePath)
                .appending(
                    queryItems: [.init(name: Constants.query, value: query)]
                )
        )
        request.setValue(
            "\(Constants.bearerTokenKey) \(apiKey)",
            forHTTPHeaderField: Constants.headerAuthorizationKey
        )

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            guard
                let movieSearchResult = try? JSONDecoder().decode(
                    MovieSearchResultDto.self,
                    from: data
                )
            else { return [] }
            return movieSearchResult.results
        } catch {
            debugPrint("Invalid data")
        }
        return []
    }
}
