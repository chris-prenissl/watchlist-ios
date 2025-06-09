class SearchRepository {
    let client: TMDBClient

    init(client: TMDBClient) {
        self.client = client
    }

    func search(query: String) async -> [MovieSearchItem] {
        let result = await client.searchMovie(query: query)
        return result.map { $0.toEntity() }
    }
}
