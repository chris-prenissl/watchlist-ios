import Combine
import Foundation

@Observable
class SearchViewModel: ObservableObject {
    private let searchRepository: SearchRepository

    var movieSearchItems: [MovieSearchItem] = []

    init(movieSearchItems: [MovieSearchItem] = [], searchRepository: SearchRepository) {
        self.movieSearchItems = movieSearchItems
        self.searchRepository = searchRepository
    }

    func searchMovies(query: String) async {
        let result = await searchRepository.search(query: query)
        await MainActor.run {
            movieSearchItems = result
        }
    }
}
