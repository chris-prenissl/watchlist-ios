import Foundation
import Combine

class RemoteMovieDataSource {
    func searchMovies(query: String) -> AnyPublisher<MovieSearchResultItemDto, Error> {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieSearchResultItemDto.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

