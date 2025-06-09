import Foundation

class TMDBClient {
    private let apiKey: String
    private let baseUrl = URL(string: "https://api.themoviedb.org/3")!

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
            fatalError("Failed to load Secrets.plist")
        }
        self.apiKey = apiKey
    }

    func searchMovie(query: String) async -> [MovieSearchItemDto] {
        var request = URLRequest(
            url:
                baseUrl
                .appendingPathComponent("search/movie")
                .appending(queryItems: [.init(name: "query", value: query)])
        )
        request.setValue(
            "Bearer \(apiKey)",
            forHTTPHeaderField: "Authorization"
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
