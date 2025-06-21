class SearchRepository {
    let client: TMDBClientProtocol

    init(client: TMDBClientProtocol) {
        self.client = client
    }

    func search(query: String) async throws -> [MovieSearchItem] {
        let result = try await client.searchMovie(query: query)
        return result.map { $0.toEntity() }
    }
}
