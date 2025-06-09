import Combine
import Foundation

class SearchViewModel: ObservableObject {
    private let searchRepository: SearchRepository

    @Published var movieSearchItems: [MovieSearchItem] = []

    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }

    func searchMovies(query: String) async {
        let result = await searchRepository.search(query: query)
        await MainActor.run {
            movieSearchItems = result
        }
    }
}
