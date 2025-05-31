import OpenAPIRuntime
import OpenAPIURLSession

class SearchRepository {
    let client: TMDBClient

    init(client: TMDBClient) {
        self.client = client
    }

    func search(query: String) async throws -> [MovieSearchItem] {
        do {
            let result = try await client.client.searchMovie(
                query: Operations.searchMovie.Input.Query(query: query),
                headers: Operations.searchMovie.Input.Headers()
            )
            switch result {
            case .ok(let response):
                return try! response.body.json.toMovieSearchItems()

            case .undocumented(let statusCode, _):
                debugPrint(statusCode)
                return []
            }
        } catch {
            debugPrint(error)
            return []
        }
    }
}
