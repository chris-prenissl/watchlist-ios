import Combine
import Foundation

@Observable
class SearchViewModel: ObservableObject {
    private let searchRepository: SearchRepository

    var state: ViewState
    var query: String = ""
    var movieSearchItems: [MovieSearchItem] = []

    init(
        searchRepository: SearchRepository,
        state: ViewState = .loaded,
        movieSearchItems: [MovieSearchItem] = [],
    ) {
        self.searchRepository = searchRepository
        self.state = state
        self.movieSearchItems = movieSearchItems
    }

    func searchMovies(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        if trimmedQuery.isEmpty {
            await MainActor.run {
                self.state = .loaded
                self.query = ""
                self.movieSearchItems = []
            }
            return
        }

        if trimmedQuery == self.query {
            await MainActor.run {
                self.state = .loaded
            }
        }

        do {
            await MainActor.run {
                self.state = .loading
                self.query = trimmedQuery
            }
            let result = try await searchRepository.search(query: trimmedQuery)

            await MainActor.run {
                self.movieSearchItems = result
                self.state = .loaded
            }
        } catch {
            await MainActor.run {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
