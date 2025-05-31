import OpenAPIRuntime

extension Operations.searchMovie.Output.Ok.Body.jsonPayload {
    func toMovieSearchItems() -> [MovieSearchItem] {
        return self.results?.map { result in
            MovieSearchItem(
                id: result.id ?? 0,
                title: result.title ?? "",
                description: result.overview ?? ""
            )
        } ?? []
    }
}
