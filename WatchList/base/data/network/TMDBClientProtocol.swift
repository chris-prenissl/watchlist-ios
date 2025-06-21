protocol TMDBClientProtocol {
    func searchMovie(query: String) async -> [MovieSearchItemDto]
}
