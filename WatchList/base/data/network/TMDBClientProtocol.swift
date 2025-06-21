protocol TMDBClientProtocol {
    func searchMovie(query: String) async throws -> [MovieSearchItemDto]
}
