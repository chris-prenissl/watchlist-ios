class SearchRepository {
    let client: TMDBClientProtocol

    init(client: TMDBClientProtocol) {
        self.client = client
    }

    func search(query: String) async -> [MovieSearchItem] {
        let result = await client.searchMovie(query: query)
        return result.map { $0.toEntity() }
    }
}
